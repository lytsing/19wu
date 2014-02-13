class AddCanceledAtToCourseOrders < ActiveRecord::Migration
  def change
    add_column :course_orders, :canceled_at, :timestamp
  end
end
