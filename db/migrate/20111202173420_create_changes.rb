class CreateChanges < ActiveRecord::Migration
  def change
    create_table :changes do |t|
      t.integer :revision
      t.string :status
      t.string :project_root
      t.string :filepath
      t.string :fullpath
      t.integer :commit_id

      t.timestamps
    end
  end
end
