class RenameUserColumnInCommits < ActiveRecord::Migration
  def change
    rename_column :commits, :user_id, :committer_id
  end
end
