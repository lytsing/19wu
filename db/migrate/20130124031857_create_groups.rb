class CreateGroups < ActiveRecord::Migration
  def up
    create_table :groups do |t|
      t.integer :user_id, :null => false
      t.string :slug, :null => false

      t.timestamps
    end
    add_index :groups, :slug, :unique => true

    add_column :courses, :group_id, :integer
    add_index :courses, :group_id
    Event.all.each do |course|
      course.update_attributes! :slug => "e#{course.id}"
    end
    change_column :courses, :group_id, :integer, :null => false
  end

  def down
    drop_table :groups
    remove_column :courses, :group_id
  end
end
