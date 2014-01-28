class AddAbstractToEvents < ActiveRecord::Migration
  def change
    add_column :events, :abstract, :text
  end
end

