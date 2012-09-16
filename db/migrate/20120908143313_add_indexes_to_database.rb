class AddIndexesToDatabase < ActiveRecord::Migration
  def up
    add_index :committers,   :project_id
    add_index :commits, :committer_id
    add_index :commits, :datetime
    add_index :changes, :commit_id
  end
  
  def down
    remove_index :committers,   :project_id
    remove_index :commits, :committer_id
    remove_index :commits, :datetime
    remove_index :changes, :commit_id
  end
end
