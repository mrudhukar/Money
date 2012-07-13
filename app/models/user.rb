class User < ActiveRecord::Base
  module Notification
    IMMEDIATE = 0
    DAILY = 1
    WEEKLY = 2
    NONE = 3

    def self.all
      [IMMEDIATE, DAILY, WEEKLY, NONE]
    end
  end

  acts_as_authentic

  validates :name, :presence => true
  validates :notification_setting, :presence => true, :inclusion => {:in => Notification.all}

  has_many :group_users, :dependent => :destroy
  has_many :groups, :through => :group_users

  has_many :active_group_users, :class_name => "GroupUser", :conditions => {:status => GroupUser::Status::ACTIVE}
  has_many :active_groups, :through => :active_group_users, :source => :group

  has_many :admin_groups, :class_name => "Group"
  has_many :items

  has_many :supports

  scope :daily_notified, where(:notification_setting => Notification::DAILY)
  scope :weekly_notified, where(:notification_setting => Notification::WEEKLY)

  before_validation(:on => :create) do
    self.last_notified_at = Time.now
  end

  attr_protected :app_admin

  def display_name
    self.nick_name || self.name
  end

  def notify_immediately?
    self.notification_setting == Notification::IMMEDIATE
  end

  def send_periodic_updates(period)
    items = self.items.where(:created_at => self.last_notified_at..Time.now).includes(:common_item => [:group_user])
    non_ownered_items = items.reject{|item| item.common_item.user == self}

    unless non_ownered_items.empty?
      grouped_items = non_ownered_items.collect(&:common_item).group_by(&:group)
      UserMailer.periodic_update(self, grouped_items, non_ownered_items, period).deliver
      self.update_attribute(:last_notified_at, Time.now)
    end
  end

  def self.send_daily_updates
    User.daily_notified.where("last_notified_at < ?", 1.day.ago).all.each do |user|
      user.send_periodic_updates("daily")
    end
  end

  def self.send_weekly_updates
    User.weekly_notified.where("last_notified_at < ?", 1.week.ago).all.each do |user|
      user.send_periodic_updates("weekly")
    end
  end

  def send_forgot_password!
    reset_perishable_token!
    UserMailer.forgot_password(self).deliver
  end  

end