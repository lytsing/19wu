class AddUserIdToCourses < ActiveRecord::Migration
  def change
    Course.destroy_all # destroy it before release is safe.
    #add_column :courses, :user_id, :integer, :null => false #197
    add_column :courses, :user_id, :integer
    change_column :courses, :user_id, :integer, :null => false
  end
end
