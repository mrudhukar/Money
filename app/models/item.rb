class Item < ActiveRecord::Base
  belongs_to :user
  belongs_to :common_item

  validates :user, :common_item, :presence => true

  after_create :increment_balance
  after_destroy :decrement_balance

  [:name, :transaction_date].each do |method_name|
    delegate method_name, :to => :common_item
  end

  def group_user
    self.common_item.group.get_group_user(self.user)
  end

  private

  def increment_balance
    self.user.update_attribute(:net_balance, self.user.net_balance + self.default_amount)
    self.group_user.update_attribute(:balance, self.group_user.balance + self.default_amount)
  end

  def decrement_balance
    self.user.update_attribute(:net_balance, self.user.net_balance - self.default_amount)
    if self.group_user
      self.group_user.update_attribute(:balance, self.group_user.balance - self.default_amount)
    end
  end

end
