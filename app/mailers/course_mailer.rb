class CourseMailer < ActionMailer::Base
  default from: Settings.email[:from]

  def change_email(change, user)
    @change = change
    @course = change.course
    @user = user
    mail(to: user.email_with_login, subject: I18n.t('email.course.change.subject', title: @course.title))
  end
end
