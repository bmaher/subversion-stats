class AddCommitterCountToProject < ActiveRecord::Migration
  def change
    add_column :projects, :committers_count, :integer, :default => 0, :null => false
  end
end
