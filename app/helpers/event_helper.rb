module CourseHelper

  def time_merge(course)
    start_time = course.start_time
    end_time = course.end_time
    text = start = I18n.localize(start_time, :format => format_year(start_time)) # http://j.mp/11ycCAB
    unless end_time.nil?
      format = if same_day?(start_time, end_time)
                 same_noon?(start_time, end_time) ? :time : :noon_time
               else
                 format_year(end_time)
               end
      text += " - #{I18n.localize(end_time, :format => format)}"
    end
    text
  end

  def group_course_path(course)
    group = course.group
    (course == group.courses.latest.first) ? slug_course_path(group.slug) : url_for(
      :controller => 'courses',
      :action => 'show',
      :id => course.id
    )
  end

  def group_course_followers_path(course)
    group = course.group
    (course == group.courses.latest.first) ? slug_course_path(group.slug)+"/followers" : url_for(
      :controller => 'courses',
      :action => 'followers',
      :id => course.id
    )
  end

  def course_follow_info(course)
    entry = [ course.group.followers_count, t('views.follow.state'), false ]
    entry[2] = true if current_user.try(:following?, course.group)
    entry.to_json
  end

  def build_summary_title(course)
    if course.course_summary
      return I18n.t("views.summary")
    elsif !course.finished? && course.group.last_course_with_summary
      return I18n.t("views.previous_summary") + "(#{course.group.last_course_with_summary.start_time.strftime('%Y%m%d')})"
    end
  end

  def build_summary_content(course)
    if course.course_summary
      return course.course_summary.content_html
    elsif !course.finished? && course.group.last_course_with_summary
      return course.group.last_course_with_summary.course_summary.content_html
    end
  end

  def init_course(course)
    {
      'course.id' => course.id,
      'course.started' => course.started?
    }.to_ng_init
  end

  private
  def format_year(time)
    (time.year == Time.zone.now.year) ? :stamp : :stamp_with_year
  end

  def same_day?(time1, time2)
    time1.to_date == time2.to_date
  end

  def same_noon?(time1, time2)
    time1.strftime('%P') == time2.strftime('%P')
  end

  def history_url_text(course)
    course.start_time.strftime("%Y-%m-%d ") + I18n.t('views.history.participants', number: course.ordered_users.size)
  end

end
