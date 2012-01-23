class User < ActiveRecord::Base
  module Notification
    IMMEDIATE = 0
    DAILY = 1
    WEEKLY = 2

    def self.all
      [IMMEDIATE, DAILY, WEEKLY]
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

  scope :periodic_notified, where(:notification_setting => [Notification::DAILY, Notification::WEEKLY])

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

  def self.send_periodic_updates
    User.periodic_notified.where("last_notified_at < ?", 1.day.ago).all.each do |user|
      items = user.items.where(:created_at => user.last_notified_at..Time.now).includes(:commont_item => [:group_user])
      non_ownered_items = items.reject{|item| item.common_item.user == user}

      next if non_ownered_items.empty?

      grouped_items = non_ownered_items.collect(&:common_item).group_by(&:group)
      UserMailer.periodic_update(user, grouped_items, non_ownered_items).deliver
      user.update_attribute(:last_notified_at, Time.now)
    end
  end
end
