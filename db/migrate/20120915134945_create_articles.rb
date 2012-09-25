class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :uid
      t.string :subject
      t.string :from
      t.datetime :date
      t.integer :size
      t.integer :lines
      t.belongs_to :segment
      t.boolean :pending, default: true
      t.timestamps
    end
  end
end
