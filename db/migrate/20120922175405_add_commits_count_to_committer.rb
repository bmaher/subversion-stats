class AddCommitsCountToCommitter < ActiveRecord::Migration
  def change
    add_column :committers, :commits_count, :integer, :default => 0, :null => false
  end
end
