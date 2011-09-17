class Group < ActiveRecord::Base
  acts_as_redeemable

  belongs_to :admin, :class_name => 'User', :foreign_key => :user_id
  belongs_to :redeemed_by, :class_name => "User", :foreign_key => "redeemed_by_id"

  has_many :group_users, :dependent => :destroy, :order => "balance DESC"
  has_many :users, :through => :group_users
  has_many :common_items, :through => :group_users, :order => "transaction_date DESC"

  validates :name, :admin, :presence => true

  def get_group_user(user)
    self.group_users.find_by_user_id(user.id)
  end

end