# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120925190243) do

  create_table "articles", :force => true do |t|
    t.string   "uid"
    t.string   "subject"
    t.string   "from"
    t.datetime "date"
    t.integer  "size"
    t.integer  "lines"
    t.integer  "segment_id"
    t.boolean  "pending",    :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "articles", ["segment_id"], :name => "index_articles_on_segment_id"
  add_index "articles", ["uid"], :name => "index_articles_on_uid", :unique => true

  create_table "articles_groups", :id => false, :force => true do |t|
    t.integer "article_id"
    t.integer "group_id"
  end

  add_index "articles_groups", ["article_id", "group_id"], :name => "index_articles_groups_on_article_id_and_group_id", :unique => true

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "groups_releases", :id => false, :force => true do |t|
    t.integer "release_id"
    t.integer "group_id"
  end

  add_index "groups_releases", ["release_id", "group_id"], :name => "index_groups_releases_on_release_id_and_group_id", :unique => true

  create_table "references", :force => true do |t|
    t.integer  "number"
    t.integer  "article_id"
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "references", ["article_id"], :name => "index_references_on_article_id"
  add_index "references", ["group_id"], :name => "index_references_on_group_id"

  create_table "regular_expressions", :force => true do |t|
    t.string   "value"
    t.boolean  "process_placeholders", :default => true
    t.integer  "segments_count",       :default => 0
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "priority",             :default => 0
  end

  create_table "release_file_segments", :force => true do |t|
    t.integer  "number"
    t.integer  "file_id"
    t.integer  "regular_expression_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "release_file_segments", ["file_id"], :name => "index_release_file_segments_on_file_id"

  create_table "release_files", :force => true do |t|
    t.string   "name"
    t.integer  "number"
    t.integer  "size"
    t.integer  "total_segments"
    t.integer  "release_id"
    t.boolean  "complete",       :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "release_files", ["release_id"], :name => "index_release_files_on_release_id"

  create_table "releases", :force => true do |t|
    t.string   "name"
    t.string   "poster"
    t.integer  "size"
    t.integer  "total_files"
    t.integer  "files_count", :default => 0
    t.boolean  "complete",    :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "releases", ["complete", "name", "poster", "total_files"], :name => "index_releases_on_complete_and_name_and_poster_and_total_files"

end
