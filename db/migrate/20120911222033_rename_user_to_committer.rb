class RenameUserToCommitter < ActiveRecord::Migration
  def change
    rename_table :users, :committers
  end
end
