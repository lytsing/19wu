class Group < ActiveRecord::Base
  belongs_to :user
  has_many :courses
  has_many :collaborators, class_name: "GroupCollaborator"
  has_many :topics, class_name: "GroupTopic"
  acts_as_followable

  def collaborator?(user)
    self.collaborators.exists?(user_id: user.id)
  end

  def last_course_with_summary
    courses.latest.each do |course|
      return course unless course.course_summary.nil?
    end
    nil
  end
end
