class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.integer :revision
      t.integer :user_id
      t.string :datetime
      t.string :message

      t.timestamps
    end
  end
end
