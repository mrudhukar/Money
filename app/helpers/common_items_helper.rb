module CommonItemsHelper
  def display_amount(user, common_item)
    item = user.items.find_by_common_item_id(common_item.id)
    if item
      "Rs. #{item.default_amount}"
    else
      ""
    end
  end

  def display_amount_for_suspended_users(sus_g_users, common_item)
    string = ""
    sus_g_users.each do |g_user|
      disp_amt = display_amount(g_user.user, common_item)
      string += "#{g_user.name} - #{disp_amt} &nbsp;" unless disp_amt.blank?
    end
    return string.html_safe
  end

  def show_delete_link(common_item)
    if current_user == common_item.user
      content_tag(:span, :class => "label important") do
        link_to "Delete", group_common_item_path(common_item.group, common_item), :confirm => 'Are you sure?',:method => :delete
      end
    end
  end
end
