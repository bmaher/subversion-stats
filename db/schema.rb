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

ActiveRecord::Schema.define(:version => 20120911222506) do

  create_table "changes", :force => true do |t|
    t.integer  "revision"
    t.string   "status"
    t.string   "project_root"
    t.string   "filepath"
    t.string   "fullpath"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "commit_id"
  end

  add_index "changes", ["commit_id"], :name => "index_changes_on_commit_id"

  create_table "committers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  add_index "commiters", ["project_id"], :name => "index_users_on_project_id"

  create_table "commits", :force => true do |t|
    t.integer  "revision"
    t.integer  "committer_id"
    t.string   "datetime"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commits", ["committer_id"], :name => "index_commits_on_committer_id"
  add_index "commits", ["datetime"], :name => "index_commits_on_datetime"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
