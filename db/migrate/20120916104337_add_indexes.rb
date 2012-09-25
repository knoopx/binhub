class AddIndexes < ActiveRecord::Migration
  def change
    add_index :articles, :segment_id
    add_index :articles, :uid, unique: true

    add_index :articles_groups, [:article_id, :group_id], unique: true
    add_index :groups_releases, [:release_id, :group_id], unique: true
    add_index :releases, [:complete, :name, :poster, :total_files]
    add_index :release_files, :release_id
    add_index :release_file_segments, :file_id
  end
end
