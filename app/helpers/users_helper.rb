module UsersHelper
  def notification_options(user)
    options_for_select([
        ["Immediate", User::Notification::IMMEDIATE],
        ["Daily digest", User::Notification::DAILY],
        ["Weekly digest", User::Notification::WEEKLY],
        ["No notification", User::Notification::NONE]
    ], :selected => user.notification_setting)
  end
end
