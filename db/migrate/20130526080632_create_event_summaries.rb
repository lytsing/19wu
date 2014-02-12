class CreateEventSummaries < ActiveRecord::Migration
  def up
    create_table :course_summaries do |t|
      t.text :content
      t.integer :course_id
      
      t.timestamp
    end
  end

  def down
    drop_table :course_summaries
  end
end
