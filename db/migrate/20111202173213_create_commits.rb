class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.integer :revision
      t.string :datetime
      t.string :message
      t.integer :committer_id

      t.timestamps
    end
  end
end
