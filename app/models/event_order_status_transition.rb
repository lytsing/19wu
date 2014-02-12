class CourseOrderStatusTransition < ActiveRecord::Base
  belongs_to :course_order
end
