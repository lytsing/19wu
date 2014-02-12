# -*- coding: utf-8 -*-
class EventOrdersController < ApplicationController
  include AlipayGeneratable
  include HasApiResponse
  before_filter :authenticate_user!, only: [:create]
  before_filter :authorize_course!, only: [:stats, :index]

  set_tab :order, only: [:stats, :index]

  [:pending, :paid, :canceled, :closed, :refund_pending].each do |item|
    set_tab item, :sidebar, only: [:stats, :index]
  end

  def create
    course = Event.find params[:course_id]

    current_user.update_attributes! user_params
    @order = EventOrder.place_order current_user, course, order_params

    respond_to do |format|
      format.json
    end
  end

  def index
    params[:q] ||= {}
    params[:q][:status_eq] = params[:status]
    @search = @course.orders.search params[:q]
    @orders = @search.result
  end

  def stats
    @orders = @course.orders.includes(items: :ticket)
  end

  private

  def user_params
    params.fetch(:user, {}).permit(:phone, profile_attributes: [:name])
  end

  def order_params
    params.fetch(:order, {}).permit({
      items_attributes: [:ticket_id, :quantity],
      shipping_address_attributes: [:invoice_title, :province, :city, :district, :address, :name, :phone]
    })
  end
end
