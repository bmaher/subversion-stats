class AddCommitIdToChange < ActiveRecord::Migration
  def change
    add_column :changes, :commit_id, :int
  end
end
