class AddNumberToOrder < ActiveRecord::Migration
  def up
    add_column :course_orders, :number, :string, limit: 16
    CourseOrder.all.each do |order|
      order.update_column :number, Sequence.get
    end
    change_column :course_orders, :number, :string, limit: 16, null: false
  end

  def down
    remove_column :course_orders, :number
  end
end
