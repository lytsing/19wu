class RemoveCanceledAtFromEventOrders < ActiveRecord::Migration
  def change
    remove_column :course_orders, :canceled_at
  end
end
