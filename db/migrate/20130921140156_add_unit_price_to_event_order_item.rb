class AddUnitPriceToCourseOrderItem < ActiveRecord::Migration
  def change
    add_column :course_order_items, :unit_price_in_cents, :integer, default: 0, null: false
    CourseOrderItem.all.each do |course_order_item|
      course_order_item.update_column :unit_price_in_cents, (course_order_item.price_in_cents / course_order_item.quantity)
    end
  end
end
