class CreateReleasesGroups < ActiveRecord::Migration
  def change
    create_table :groups_releases, force: true, id: false do |t|
      t.belongs_to :release
      t.belongs_to :group
    end
  end
end
