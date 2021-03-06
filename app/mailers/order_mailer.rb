class OrderMailer < ActionMailer::Base
  include AlipayGeneratable
  default from: Settings.email[:from]

  def notify_user_created(order)
    @order = order
    @course = order.course
    @user = order.user
    mail(to: @user.email_with_login, subject: I18n.t('email.order.user.created.subject'))
  end

  def notify_organizer_created(order)
    @order = order
    @course = order.course
    @user = order.user
    mail(to: @course.user.email_with_login, subject: I18n.t('email.order.organizer.created.subject', title: @course.title, number: @order.number, login: @user.login ))
  end

  def notify_user_paid(order)
    @order = order
    @course = order.course
    @user = order.user
    mail(to: @user.email_with_login, subject: I18n.t('email.order.user.paid.subject', number: order.number))
  end

  def notify_user_checkin_code(participant)
    @participant = participant
    @order = participant.order
    @course = @order.course
    @user = @order.user
    mail(to: @user.email_with_login, subject: I18n.t('email.order.user.checkin_code.subject', number: @order.number, code: participant.checkin_code))
  end

  def notify_organizer_paid(order)
    @order = order
    @course = order.course
    @user = order.user
    mail(to: @course.user.email_with_login, subject: I18n.t('email.order.organizer.paid.subject', title: @course.title, number: @order.number, login: @user.login ))
  end

  def notify_support_refund(refund)
    @refund = refund
    @order = refund.order
    @course = @order.course
    mail(to: Settings.email[:from], subject: I18n.t('email.order.support.refund.subject', title: @course.title, number: @order.number))
  end

  def notify_user_refunded(refund)
    @refund = refund
    @order = refund.order
    @course = @order.course
    @user = @order.user
    mail(to: @order.user.email_with_login, subject: I18n.t('email.order.user.refund.subject', title: @course.title, number: @order.number, amount: refund.amount))
  end

  def notify_organizer_refunded(refund)
    @refund = refund
    @order = refund.order
    @course = @order.course
    @user = @order.user
    mail(to: @course.user.email_with_login, subject: I18n.t('email.order.organizer.refund.subject', title: @course.title, number: @order.number, login: @user.login, amount: refund.amount))
  end
end
