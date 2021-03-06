class ChangePriceToPriceInCents < ActiveRecord::Migration
  def up
    add_column :course_tickets    , :price_in_cents, :integer, null: false, default: 0
    add_column :course_orders     , :price_in_cents, :integer, null: false, default: 0
    add_column :course_order_items, :price_in_cents, :integer, null: false, default: 0
    CourseTicket.all.each { |ticket| ticket.update_column :price_in_cents, (ticket.attributes['price'] * 100).to_i }
    CourseOrder.all.each  { |order| order.update_column :price_in_cents, (order.attributes['price'] * 100).to_i }
    CourseOrderItem.all.each  { |item| item.update_column :price_in_cents, (item.attributes['price'] * 100).to_i }
    remove_column :course_tickets    , :price
    remove_column :course_orders     , :price
    remove_column :course_order_items, :price
  end

  def down
    add_column :course_tickets    , :price, :float, null: false, default: 0
    add_column :course_orders     , :price, :float, null: false, default: 0
    add_column :course_order_items, :price, :float, null: false, default: 0
    CourseTicket.all.each { |ticket| ticket.update_column :price, ticket.price_in_cents / 100.0 }
    CourseOrder.all.each  { |order| order.update_column :price, order.price_in_cents / 100.0 }
    CourseOrderItem.all.each  { |item| item.update_column :price, item.price_in_cents / 100.0 }
    remove_column :course_tickets    , :price_in_cents
    remove_column :course_orders     , :price_in_cents
    remove_column :course_order_items, :price_in_cents
  end
end
