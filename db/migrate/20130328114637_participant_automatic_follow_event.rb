class ParticipantAutomaticFollowCourse < ActiveRecord::Migration
  def up
    Course.all.each do |course|
      group = course.group
      course.participated_users.each do |user|
        user.follow group
      end
    end
  end

  def down
  end
end
