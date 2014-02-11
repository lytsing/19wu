class AddContactAnTelToEvents < ActiveRecord::Migration
  def change
    add_column :events, :contact, :text
    add_column :events, :telephone, :text
    
  end
end
