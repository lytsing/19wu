class EventChange < ActiveRecord::Base
  belongs_to :course
  validates :content, length: { maximum: 100 }

  after_create do
    course.ordered_users.each do |user|
      EventMailer.delay.change_email(self, user)
    end
    phones = course.ordered_users.with_phone.map(&:phone).sort
    ChinaSMS.delay.to phones, I18n.t('sms.course.change', content: content)
  end
end
