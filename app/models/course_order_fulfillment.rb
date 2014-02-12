class CourseOrderFulfillment < ActiveRecord::Base
  belongs_to :order, class_name: 'CourseOrder'
  validates :tracking_number, presence: true
  validates :tracking_number, length: { is: 12 }, allow_blank: true

  after_create do
    OrderFulfillmentMailer.delay.notify_user_fulfilled(self)
    OrderFulfillmentMailer.delay.notify_organizer_fulfilled(self)
  end
end
