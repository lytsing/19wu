class EventOrder < ActiveRecord::Base
  belongs_to :course
  belongs_to :user
  has_many :course_order_status_transitions
  has_many :items, class_name: 'EventOrderItem', foreign_key: "order_id"
  has_many :refunds, class_name: 'EventOrderRefund', foreign_key: "order_id"
  has_one :participant     , class_name: 'EventOrderParticipant'    , foreign_key: "order_id"
  has_one :shipping_address, class_name: 'EventOrderShippingAddress', foreign_key: "order_id"
  has_one :fulfillment     , class_name: 'EventOrderFulfillment'    , foreign_key: "order_id"
  priceable :price, :paid_amount

  accepts_nested_attributes_for :items, :shipping_address

  validates :course_id, :user_id, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validate :quantity_cannot_be_greater_than_course_quantity, :invoice_should_has_address, on: :create

  before_validation do
    self.quantity = calculate_quantity
    self.price_in_cents = calculate_price_in_cents
  end

  before_create do
    self.status = free? ? 'paid' : 'pending'
    course.decrement! :tickets_quantity, self.quantity if course.tickets_quantity
    self.number = Sequence.get
  end

  after_create do
    self.create_participant if free?
    OrderMailer.delay.notify_user_created(self)
    OrderMailer.delay.notify_organizer_created(self)
    user.follow course.group
  end

  def free?
    self.price_in_cents.zero?
  end

  def status_name
    I18n.t(self.status, scope: 'activerecord.state_machines.course_order.states')
  end

  # TODO: use financial status to track partial refund and refunded status
  state_machine :status, :initial => :pending do
    store_audit_trail

    state :pending, :canceled, :closed
    state :refund_pending do
      validates :trade_no, :presence => true
    end

    course :pay do
      transition :pending => :paid, :if => ->(order) { !order.course.finished? }
    end

    course :cancel do # use order.cancel instead of order.cancel! if you don't want to raise error when order has been finished.
      transition  [:pending, :paid, :refund_pending] => :canceled, :if => ->(order) { !order.course.finished? }
    end

    course :request_refund do
      transition :paid => :refund_pending, :if => ->(order) { order.course.start_time - Time.now > 7.days }
    end

    course :close do
      transition :pending => :closed
    end
  end

  # override state_machine generated method to accept trade_no
  def pay(trade_no = nil)
    self.trade_no = trade_no
    super
  end

  def pay_with_bank_transfer?
    self.trade_no.blank? # for now, only bank transfer was supported.
  end

  def require_invoice
    items.map(&:require_invoice).any?
  end

  class<< self
    def build_order(user, course, params)
      items_attributes = EventOrderItem.filter_attributes(
          course,
          params[:items_attributes]
      )
      order_params = {
          user: user,
          status: :pending,
          items_attributes: items_attributes
      }
      order_params[:shipping_address_attributes] = params[:shipping_address_attributes] if params[:shipping_address_attributes]
      course.orders.build order_params
    end

    # TODO: validate, course and its inventory, #457, #467
    def place_order(user, course, params)
      build_order(user, course, params).tap do |order|
        order.save!
      end
    end

    def statuses
      state_machines[:status].states.map(&:name)
    end

    def cleanup_expired
      where(status: :pending).where('created_at < ?', 3.days.ago).each(&:close)
    end
  end

  private

  def quantity_cannot_be_greater_than_course_quantity
    return unless course.tickets_quantity
    order_quantity = self.quantity || 0
    if course.tickets_quantity == 0 || order_quantity > course.tickets_quantity
      errors.add(:quantity, I18n.t('errors.messages.quantity_overflow'))
    end
  end

  def invoice_should_has_address
    if self.require_invoice && shipping_address.nil?
      errors.add(:shipping_address, I18n.t('errors.messages.course_order.miss_shipping_address'))
    end
  end

  def calculate_quantity
    items.map(&:quantity).sum
  end

  def calculate_price_in_cents
    items.map(&:price_in_cents).sum
  end
end
