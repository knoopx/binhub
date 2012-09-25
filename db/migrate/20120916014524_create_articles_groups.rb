class CreateArticlesGroups < ActiveRecord::Migration
  def change
    create_table :articles_groups, force: true, id: false do |t|
      t.belongs_to :article
      t.belongs_to :group
    end
  end
end
