class AddAbstractToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :abstract, :text
  end
end

