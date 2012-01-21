class User < ActiveRecord::Base
  module Notification
    IMMEDIATE = 0
    DAILY = 1
    WEEKLY = 2
  end

  acts_as_authentic

  validates :name, :presence => true

  has_many :group_users, :dependent => :destroy
  has_many :groups, :through => :group_users

  has_many :active_group_users, :class_name => "GroupUser", :conditions => {:status => GroupUser::Status::ACTIVE}
  has_many :active_groups, :through => :active_group_users, :source => :group

  has_many :admin_groups, :class_name => "Group"
  has_many :items

  attr_protected :app_admin

  def display_name
    self.nick_name || self.name
  end

  def notify_immediately?
    self.notification_setting == Notification::IMMEDIATE
  end

  def self.send_periodic_updates
    #TODO periodic_update
  end
end