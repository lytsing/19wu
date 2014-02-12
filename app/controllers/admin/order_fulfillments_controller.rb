class Admin::OrderFulfillmentsController < ApplicationController
  include HasApiResponse
  before_filter :authenticate_user!
  before_filter :authorize_order!

  def index
    @orders = CourseOrder.where(status: 'paid').joins(items: :ticket).where(course_tickets: {require_invoice: true}).order('paid_amount_in_cents asc, id asc')
  end

  def create
    order = CourseOrder.find(params[:order_id])
    @fulfillment = order.create_fulfillment!(params.fetch(:fulfillment).permit(:tracking_number))
  end

  private
  def authorize_order!
    authorize! :manage_fulfillment, CourseOrder
  end
end
