module UserMailerHelper
  def notification_setting_link(user)
    settings_url = edit_user_url(user)
    settings_link = link_to('change your notification settings', settings_url)
    cur_notif_setting = user.notification_setting
    content_tag(:small, :style => 'color: #888; border-top: 1px solid #D7D4C6; padding-top: 5px;margin-top: 20px; display:block;') do
      content =
      if cur_notif_setting == User::Notification::DAILY
        "Messages sent to you are aggregated and delivered once a day. To receive messages sent to you immediately or once a week, #{settings_link}."
      elsif cur_notif_setting == User::Notification::WEEKLY
        "Messages sent to you are aggregated and delivered once a week. To receive messages sent to you immediately or once a day, #{settings_link}."
      else
        "To get your updates only once a day or a week, #{settings_link}."
      end
      content.html_safe
    end
  end
end
