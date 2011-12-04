class AddIndexToDatetime < ActiveRecord::Migration
  def self.up
    add_index :commits, :datetime
  end
  
  def self.down
    remove_index :commits, :datetime
  end
end