# -*- coding: utf-8 -*-
class EventObserver < ActiveRecord::Observer
  def before_create(course)
    save_group course
  end

  def after_create(course)
    notify_followers course
    course.tickets.create name: '资费项目', price: 0
  end

  def before_update(course)
    if course.slug
      group = course.group
      if group and group.slug != course.slug and group.courses.size <= 1
        group.destroy
        fallback_url = FallbackUrl.find_or_initialize_by origin: group.slug
        fallback_url.change_to = course.slug
        fallback_url.save
      end
      save_group course
    end
  end

  def after_find(course)
    course.slug ||= course.group.try(:slug)
  end

  private

  def save_group(course)
    group = course.user.groups.where(:slug => course.slug).first_or_create!
    course.group = group
  end

  def notify_followers(course)
    course.group.followers.each do |follower|
      UserMailer.delay.notify_email follower, course
    end
  end
end
