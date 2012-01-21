class UserMailer < ActionMailer::Base
  include CommonItemsHelper
  LINK_BUTTON = "background-color:#5678BE;width:170px;border:1px solid #365FB6;margin-top: 15px;-moz-border-radius:5px;-webkit-border-radius:5px;border-radius:5px"
  LINK_TEXT = "border-left:1px solid #5678BE;border-right:1px solid #5678BE;border-top:4px solid #5678BE;border-bottom:4px solid #5678BE;font-weight:bold;font-size:13.2px;font-family:serif;text-align:center;text-decoration:none;color:#FFFFFF;display:block;"
  default :from => "Money Tracker <moneytracker@moneytracker.heroku.com>"

  def periodic_update(user)
    headers['X-Mailgun-Tag'] = 'User Periodic Update'
    mail(:to => user.email, :subject => "Money Tracker Updates,  #{Date.today.to_s(:long)}")
  end

  def transaction_notification(user, common_item)
    headers['X-Mailgun-Tag'] = 'User Transaction Notification'
    @user = user
    @common_item = common_item
    @payer = common_item.user
    @item_amount = display_amount(user, common_item)
    if common_item.payment?
      subject = "#{@common_item.group.name} - Payment recorded by #{@payer.name}"
    else
      subject = "#{@common_item.group.name} - Transaction recorded by #{@payer.name}"
    end
    mail(:to => user.email, :subject => subject)
  end

end
