# encoding: utf-8
require 'spec_helper'

describe ExportHelper do

  describe '#markdown_format_content' do
    it 'the course has not summary' do
      course = create(:course, :markdown)
      markdown_format_content(course).should == markdown_content_has_not_summary_example(course)
    end

    it 'the course has summary' do
      course = create(:course, :markdown)
      create(:course_summary, course: course)

      markdown_format_content(course).should == markdown_content_has_summary_example(course)
    end
  end

  def markdown_content_has_not_summary_example(course)
    %Q{#### #{t('activerecord.attributes.course.title')}

#{course.title}


#### #{t('views.export.course_time')}

#{time_merge(course)}


#### #{t('activerecord.attributes.course.location')}

#{course.location}


#### #{t('activerecord.attributes.course.content')}

#{course.content}}
  end

  def markdown_content_has_summary_example(course)
    %Q{#### #{t('activerecord.attributes.course.title')}

#{course.title}


#### #{t('views.export.course_time')}

#{time_merge(course)}


#### #{t('activerecord.attributes.course.location')}

#{course.location}


#### #{t('activerecord.attributes.course.content')}

#{course.content}


#### #{t('views.summary')}

#{course.course_summary.content}}
  end
end
