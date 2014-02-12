class EventTicket < ActiveRecord::Base
  belongs_to :course
  priceable :price
  validates :name, :price, presence: true
  validates :name, :description, length: { maximum: 255 }
  attr_writer :tickets_quantity
  delegate :tickets_quantity, to: :course

  before_save do
    course.update_column :tickets_quantity, @tickets_quantity if @tickets_quantity.present?
  end

  after_destroy do
    course.update_column :tickets_quantity, nil if course.tickets.count.zero?
  end
end
