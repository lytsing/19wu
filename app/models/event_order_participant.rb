class EventOrderParticipant < ActiveRecord::Base
  belongs_to :course
  belongs_to :user
  belongs_to :order, class_name: 'EventOrder'

  validates :checkin_code, uniqueness: { scope: :course_id }
  validate :cannot_checkin_again, :order_is_valid, on: :update
  after_create :send_sms, :send_email, unless: 'self.order.course.finished?'

  before_create do
    self.course = self.order.course
    self.user  = self.order.user
    self.checkin_code = self.class.unique_code(self.course)
  end

  def cannot_checkin_again
    if checkin_at_changed? and !checkin_at_was.nil?
      message = I18n.t('errors.messages.course_order_participant.used', time: checkin_at_was.to_s(:db))
      errors.add(:checkin_at, message)
    end
  end

  def order_is_valid
    unless self.order.paid?
      message = I18n.t('errors.messages.course_order_participant.invalid_order', status: order.status_name)
      errors.add(:order, message)
    end
  end

  def checkin!
    self.update_attributes! checkin_at: Time.zone.now
  end

  def joined?
    self.checkin_at
  end

  def send_email
    OrderMailer.delay.notify_user_checkin_code(self)
  end

  def send_sms
    ChinaSMS.delay.to user.phone, I18n.t('sms.course.order.checkin_code', course_title: course.title, checkin_code: self.checkin_code, course_start_time: I18n.localize(course.start_time, format: :short))
  end

  class << self
    def unique_code(course)
      code = random_code
      while course.participants.exists?(checkin_code: code)
        code = random_code
      end
      code
    end

    def random_code
      Random.rand(100000..999999).to_s
    end
  end
end
