class AddIndexesToDatabase < ActiveRecord::Migration
  def up
    add_index :users,   :project_id
    add_index :commits, :user_id
    add_index :commits, :datetime
    add_index :changes, :commit_id
  end
  
  def down
    remove_index :users,   :project_id
    remove_index :commits, :user_id
    remove_index :commits, :datetime
    remove_index :changes, :commit_id
  end
end
