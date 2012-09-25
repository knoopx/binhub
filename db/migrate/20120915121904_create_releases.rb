class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.string :name
      t.string :poster
      t.integer :size
      t.integer :total_files
      t.integer :files_count, default: 0
      t.boolean :complete, default: false
      t.timestamps
    end
  end
end
