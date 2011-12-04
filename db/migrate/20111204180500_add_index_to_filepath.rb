class AddIndexToFilepath < ActiveRecord::Migration
  def self.up
    add_index :changes, :filepath
  end
  
  def self.down
    remove_index :changes, :filepath
  end
end