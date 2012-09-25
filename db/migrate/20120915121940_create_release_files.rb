class CreateReleaseFiles < ActiveRecord::Migration
  def change
    create_table :release_files do |t|
      t.string :name
      t.integer :number
      t.integer :size
      t.integer :total_segments
      t.belongs_to :release
      t.boolean :complete, default: false
      t.timestamps
    end
  end
end
