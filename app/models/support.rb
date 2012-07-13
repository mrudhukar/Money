class Support < ActiveRecord::Base
  belongs_to :user
  validates :topic, :presence => true
  validates :description, :presence => true

  after_create :support_mail_generation

  private

  def support_mail_generation
	UserMailer.support_mail(self).deliver 
  end

end
