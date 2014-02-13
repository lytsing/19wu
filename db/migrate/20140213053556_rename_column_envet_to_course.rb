class RenameColumnEnvetToCourse < ActiveRecord::Migration
  def change
    rename_column :course_summaries, :event_id, :course_id
    rename_column :course_changes, :event_id, :course_id
    rename_column :course_order_participants, :event_id, :course_id
    rename_column :course_order_status_transitions, :event_order_id, :event_order_id
    rename_column :course_order_status_transitions, :event, :course
    rename_column :course_orders, :event_id, :course_id
    rename_column :course_summaries, :event_id, :course_id
    rename_column :course_tickets, :event_id, :course_id
  end
end
