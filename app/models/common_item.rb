class CommonItem < ActiveRecord::Base
  class Type
    SHARED_EQUALLY = 0
    SHARED_UNEQUALLY = 1
    PAYMENT = 2
    RECORD_PAYMENT = 3

    def self.all
      [SHARED_UNEQUALLY, SHARED_EQUALLY, PAYMENT, RECORD_PAYMENT]
    end
  end

  belongs_to :group_user
  has_many :items, :dependent => :destroy
  has_many :item_users, :through => :items, :source => :user
  
  validates :name, :group_user, :transaction_date, :items, :presence => true
  validates :cost, :numericality => true, :presence => true
  validates :transaction_type, :inclusion => {:in => Type.all}

  after_create :decrement_user_balance, :send_notification
  after_destroy :increment_user_balance

  def self.per_page
    50
  end

  def user
    self.group_user.user
  end

  def group
    self.group_user.group
  end

  def payment?
    self.transaction_type == Type::PAYMENT
  end

  private

  def send_notification
    (self.item_users - [self.user]).each do |user|
      next unless user.notify_immediately?
      UserMailer.transaction_notification(user, self).deliver
    end
  end

  def decrement_user_balance
    self.user.update_attribute(:net_balance, self.user.reload.net_balance - self.cost)
    self.group_user.update_attribute(:balance, self.group_user.reload.balance - self.cost)
  end

  def increment_user_balance
    if self.group_user
      self.user.update_attribute(:net_balance, self.user.net_balance + self.cost)
      self.group_user.update_attribute(:balance, self.group_user.balance + self.cost)
    end
  end
end
