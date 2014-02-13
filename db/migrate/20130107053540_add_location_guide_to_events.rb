class AddLocationGuideToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :location_guide, :text
  end
end
