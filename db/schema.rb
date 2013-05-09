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

ActiveRecord::Schema.define(:version => 20130508172955) do

  create_table "employees", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "username"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "events", :force => true do |t|
    t.integer  "employee_id"
    t.string   "punch_type"
    t.datetime "punchtime"
    t.text     "log"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "job_id"
  end

  add_index "events", ["employee_id"], :name => "index_events_on_user_id"

  create_table "jobs", :force => true do |t|
    t.string   "name"
    t.boolean  "active"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "periods", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "job_id"
    t.integer  "punch_in"
    t.integer  "punch_out"
    t.decimal  "length",      :precision => 2, :scale => 0
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "periods", ["employee_id"], :name => "index_periods_on_employee_id"
  add_index "periods", ["job_id"], :name => "index_periods_on_job_id"

end
