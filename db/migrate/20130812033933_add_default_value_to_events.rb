class AddDefaultValueToEvents < ActiveRecord::Migration
  def change
    change_column :courses, :tickets_quantity, :integer, :default => 0
  end
end
