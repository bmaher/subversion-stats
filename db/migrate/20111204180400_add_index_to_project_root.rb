class AddIndexToProjectRoot < ActiveRecord::Migration
  def self.up
    add_index :changes, :project_root
  end
  
  def self.down
    remove_index :changes, :project_root
  end
end