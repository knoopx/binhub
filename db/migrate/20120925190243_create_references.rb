class CreateReferences < ActiveRecord::Migration
  def change
    create_table :references do |t|
      t.integer :number
      t.belongs_to :article
      t.belongs_to :group
      t.timestamps
    end

    add_index :references, :article_id
    add_index :references, :group_id
  end
end
