class CreateRegularExpressions < ActiveRecord::Migration
  def change
    create_table :regular_expressions do |t|
      t.string :value
      t.boolean :process_placeholders, default: true
      t.integer :priority, default: 0
      t.integer :segments_count, default: 0
      t.timestamps
    end
  end
end
