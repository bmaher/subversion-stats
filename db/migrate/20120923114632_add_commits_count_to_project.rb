class AddCommitsCountToProject < ActiveRecord::Migration
  def change
    add_column :projects, :commits_count, :integer, :default => 0, :null => false
  end
end
