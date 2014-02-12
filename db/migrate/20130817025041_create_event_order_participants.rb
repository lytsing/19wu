class CreateEventOrderParticipants < ActiveRecord::Migration
  def change
    create_table :course_order_participants do |t|
      t.integer :order_id   , null: false
      t.integer :course_id   , null: false
      t.integer :user_id    , null: false
      t.string :checkin_code, null: false, limit: 6
      t.datetime :checkin_at

      t.timestamps
    end
    add_index :course_order_participants, [:course_id, :checkin_code], unique: true
  end
end
