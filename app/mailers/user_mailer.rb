class UserMailer < ActionMailer::Base
  include CommonItemsHelper
  LINK_BUTTON = "background-color:#5678BE;width:170px;border:1px solid #365FB6;margin-top: 15px;-moz-border-radius:5px;-webkit-border-radius:5px;border-radius:5px"
  LINK_TEXT = "border-left:1px solid #5678BE;border-right:1px solid #5678BE;border-top:4px solid #5678BE;border-bottom:4px solid #5678BE;font-weight:bold;font-size:13.2px;font-family:serif;text-align:center;text-decoration:none;color:#FFFFFF;display:block;"
  default :from => "Money Tracker <notifier@moneytracker.heroku.com>"

  def periodic_update(user, grouped_common_items, items, period)
    headers['X-Mailgun-Tag'] = "User Periodic Update - #{period}"
    headers['X-Campaign-Id'] = "User Periodic Update - #{period}"
    @user = user
    @grouped_common_items = grouped_common_items
    @items = items.group_by(&:common_item)
    mail(:to => user.email, :subject => "Money Tracker Updates,  #{Date.today.to_s(:long)}")
  end

  def transaction_notification(user, common_item)
    headers['X-Mailgun-Tag'] = 'User Transaction Notification'
    headers['X-Campaign-Id'] = 'User Transaction Notification'
    @user = user
    @common_item = common_item
    @payer = common_item.user
    @item_amount = display_amount(user, common_item)
    if common_item.payment?
      subject = "#{@common_item.group.name} - New payment recorded by #{@payer.name}"
    else
      subject = "#{@common_item.group.name} - New transaction recorded by #{@payer.name}"
    end
    mail(:to => user.email, :subject => subject)
  end

  def forgot_password(user)
    headers['X-Mailgun-Tag'] = 'User Transaction Notification'
    headers['X-Campaign-Id'] = 'User Transaction Notification'
    
    @user = user
    @reset_password_link = reset_password_url(user.perishable_token)
    
    mail(:to => user.email,
         :subject => "Reset Password Instructions") do |format|
      format.html
    end
  end  

  def support_mail(support)
    headers['X-Mailgun-Tag'] = 'Support Mail'
    headers['X-Campaign-Id'] = 'Support Mail'

    @support = support
    mail(:to => ADMIN_EMAIL, :subject => "[MONEY TRACKER] Support Request")
  end

end
