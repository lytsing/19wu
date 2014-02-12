class CreateEventTickets < ActiveRecord::Migration
  def change
    create_table :course_tickets do |t|
      t.string :name
      t.float :price
      t.string :description
      t.boolean :require_invoice
      t.integer :course_id

      t.timestamps
    end
    add_index :course_tickets, :course_id
    add_column :courses, :tickets_quantity, :integer
  end
end
