class AddAbstractToEvents < ActiveRecord::Migration
  def change
    add_column :courses, :abstract, :text
  end
end

