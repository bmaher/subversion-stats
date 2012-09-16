class CreateCommitters < ActiveRecord::Migration
  def change
    create_table :committers do |t|
      t.string :name
      t.integer :project_id

      t.timestamps
    end
  end
end
