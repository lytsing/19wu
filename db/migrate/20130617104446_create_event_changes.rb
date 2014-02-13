class CreateCourseChanges < ActiveRecord::Migration
  def change
    create_table :course_changes do |t|
      t.integer :course_id
      t.string :content

      t.timestamps
    end
    add_index :course_changes, :course_id
  end
end
