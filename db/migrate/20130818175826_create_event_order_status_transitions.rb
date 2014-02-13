class CreateCourseOrderStatusTransitions < ActiveRecord::Migration
  def change
    create_table :course_order_status_transitions do |t|
      t.references :course_order, index: true
      t.string :course
      t.string :from
      t.string :to
      t.timestamp :created_at
    end
  end
end
