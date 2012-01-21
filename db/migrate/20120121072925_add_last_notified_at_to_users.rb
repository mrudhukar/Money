class AddLastNotifiedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_notified_at, :datetime
    add_column :users, :notification_setting, :integer, :default => User::Notification::DAILY
  end
end