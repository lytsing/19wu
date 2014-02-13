class AddJoinedToCourseParticipants < ActiveRecord::Migration
  def change
    add_column :course_participants, :joined, :boolean, :null => false, :default => false
  end
end
