class CreateSegments < ActiveRecord::Migration
  def change
    create_table :release_file_segments do |t|
      t.integer :number
      t.belongs_to :file
      t.belongs_to :regular_expression
      t.timestamps
    end
  end
end
