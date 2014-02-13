class ChangeEventsToCourses < ActiveRecord::Migration
  def change
    rename_table :event_changes, :course_changes
    rename_table :event_order_fulfillments, :course_order_fulfillments
    rename_table :event_order_items, :course_order_items
    rename_table :event_order_participants, :course_order_participants
    rename_table :event_order_refunds, :course_order_refunds
    rename_table :event_order_shipping_addresses, :course_order_shipping_addresses
    rename_table :event_order_status_transitions, :course_order_status_transitions
    rename_table :event_orders, :course_orders
    rename_table :event_summaries, :course_summaries
    rename_table :event_tickets, :course_tickets
    rename_table :events, :courses
  end
end
