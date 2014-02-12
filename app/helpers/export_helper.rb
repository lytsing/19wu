require 'course_helper'

module ExportHelper
  include EventHelper

  def markdown_format_content(course)
    markdown = []
    %w(title time location content).each do |method_name|
      markdown << send("#{method_name}_markdown", course)
    end
    markdown << summary_markdown(course) if course.show_summary?
    markdown.join("\n"*3)
  end

  private
  %w(title location content).each do |field|
    class_eval %Q{
      def #{field}_markdown(course)
        [build_markdown_item_title(t('activerecord.attributes.course.#{field}')), course.#{field}].join("\n"*2)
      end
    }
  end

  def time_markdown(course)
    [build_markdown_item_title(t('views.export.course_time')), time_merge(course)].join("\n"*2)
  end

  def summary_markdown(course)
    [build_markdown_item_title(build_summary_title(course)), build_markdown_summary_content(course)].join("\n"*2)
  end

  def build_markdown_item_title(item_title)
    "#### #{item_title}"
  end

  def build_markdown_summary_content(course)
    if course.course_summary
      return course.course_summary.content
    elsif !course.finished? && course.group.last_course_with_summary
      return course.group.last_course_with_summary.course_summary.content
    end
  end
end
