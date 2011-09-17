class GroupUser < ActiveRecord::Base
  module Status
    ACTIVE    = 0
    SUSPENDED = 1
  end

  belongs_to :user
  belongs_to :group

  has_many :common_items, :dependent => :destroy

  scope :payers, where("balance > 0")
  scope :receivers, where("balance < 0")

  scope :active, where(:status => Status::ACTIVE)
  scope :suspended, where(:status => Status::SUSPENDED)

  validates :user_id, :presence => true, :uniqueness => {:scope => :group_id}
  validates :status, :presence => true, :inclusion => {:in => [Status::ACTIVE, Status::SUSPENDED]}
  validate :check_balance_before_suspension

  def items
    self.user.items.find_all_by_common_item_id(self.group.common_items.collect(&:id))
  end

  def name(full_name = false)
    full_name ? self.user.name : self.user.display_name
  end

  def active?
    self.status == Status::ACTIVE
  end

  def suspend!
    self.update_attributes(:status => Status::SUSPENDED)
  end

  def activate!
    self.update_attributes!(:status => Status::ACTIVE)
  end

  def can_be_suspend?
    self.balance == 0
  end

  private

  def check_balance_before_suspension
    if !self.can_be_suspend? && !self.active?
      errors.add(:status, "cannot be suspended when having a non zero credit")
    end
  end
end
