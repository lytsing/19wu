class AddContactAnTelToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :contact, :text
    add_column :courses, :telephone, :text
    
  end
end
