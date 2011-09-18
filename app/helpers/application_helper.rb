module ApplicationHelper
  FLASHMAP = {
    :notice => "success",
    :error => "error",
    :alert => "warning"
  }

  def render_flash
    message = flash[:notice] || flash[:error] || flash[:alert]
    key = FLASHMAP[flash.keys[0]]
    if message
      content_tag(:div, :class => "alert-message #{key}") do
        link_to("x", "#", :class => "close") + content_tag(:p, message)
      end
    end
  end

  def user_transaction_partners(group_user)
    pay_structure = PaySuggestions::PaySystem.create(group_user.group)
    payer = pay_structure.users[group_user.id]
    payer.blank? ? {} : payer.transaction_partners
  end

  def transaction_statement(group_user)
    trans = user_transaction_partners(group_user)
    string = ""
    trans.keys.each do |trans_user|
      user_name = GroupUser.find(trans_user).user.name
      string += content_tag(:span, :class => "trans_user") do
        if group_user.balance > 0
          "Pay Rs. #{trans[trans_user]} to <b> #{user_name} </b>"
        else
          "Get Rs. #{trans[trans_user]} from <b> #{user_name} </b>"
        end
      end
      string += "<br>"
    end
    return string
  end
end
