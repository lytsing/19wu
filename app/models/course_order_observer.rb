# -*- coding: utf-8 -*-
class CourseOrderObserver < ActiveRecord::Observer
  def after_pay(order, transition)
    order.create_participant
    order.increment! :paid_amount_in_cents, order.price_in_cents # convenient for refunding
    OrderMailer.delay.notify_user_paid(order)
    OrderMailer.delay.notify_organizer_paid(order)
  end

  def after_cancel(order, transition)
    order.course.increment! :tickets_quantity, order.quantity if order.course.tickets_quantity
  end

  def after_close(order, transition)
    order.course.increment! :tickets_quantity, order.quantity if order.course.tickets_quantity
  end
end
