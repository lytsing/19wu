class ParticipantAutomaticFollowEvent < ActiveRecord::Migration
  def up
    Event.all.each do |course|
      group = course.group
      course.participated_users.each do |user|
        user.follow group
      end
    end
  end

  def down
  end
end
