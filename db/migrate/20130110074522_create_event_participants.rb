class CreateCourseParticipants < ActiveRecord::Migration
  def change
    create_table :course_participants do |t|
      t.integer :course_id
      t.integer :user_id

      t.timestamps
    end

    add_index :course_participants, :course_id
    add_index :course_participants, :user_id
  end
end
