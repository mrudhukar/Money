require 'digest/sha1'
class Group < ActiveRecord::Base
  belongs_to :admin, :class_name => 'User', :foreign_key => :user_id

  has_many :group_users, :dependent => :destroy, :order => "balance DESC"
  has_many :users, :through => :group_users

  has_many :active_group_users, :class_name => "GroupUser", :conditions => {:status => GroupUser::Status::ACTIVE}
  has_many :active_users, :through => :active_group_users, :source => :user

  has_many :inactive_group_users, :class_name => "GroupUser", :conditions => {:status => GroupUser::Status::SUSPENDED}
  has_many :inactive_users, :through => :inactive_group_users, :source => :user

  has_many :common_items, :through => :group_users, :order => "transaction_date DESC"

  validates :name, :admin, :code, :presence => true

  before_validation(:on => :create) do
    self.code = Digest::SHA1.hexdigest Time.now.to_s
  end

  def get_group_user(user)
    self.group_users.find_by_user_id(user.id)
  end

end