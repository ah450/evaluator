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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151229181829) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string   "name",                        null: false
    t.text     "description",                 null: false
    t.boolean  "published",   default: false, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "courses", ["name"], name: "index_courses_on_name", unique: true, using: :btree
  add_index "courses", ["published"], name: "index_courses_on_published", using: :btree

  create_table "projects", force: :cascade do |t|
    t.datetime "due_date",                             null: false
    t.datetime "start_date",                           null: false
    t.string   "name",                                 null: false
    t.integer  "course_id"
    t.integer  "test_timeout_seconds", default: 600,   null: false
    t.boolean  "quiz",                 default: false, null: false
    t.boolean  "published",            default: false, null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "projects", ["course_id"], name: "index_projects_on_course_id", using: :btree
  add_index "projects", ["due_date"], name: "index_projects_on_due_date", using: :btree
  add_index "projects", ["name"], name: "index_projects_on_name", using: :btree
  add_index "projects", ["published"], name: "index_projects_on_published", using: :btree
  add_index "projects", ["quiz"], name: "index_projects_on_quiz", using: :btree
  add_index "projects", ["start_date"], name: "index_projects_on_start_date", using: :btree

  create_table "studentships", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "studentships", ["course_id"], name: "index_studentships_on_course_id", using: :btree
  add_index "studentships", ["student_id"], name: "index_studentships_on_student_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                            null: false
    t.string   "password_digest",                 null: false
    t.string   "email",                           null: false
    t.boolean  "student",                         null: false
    t.boolean  "verified",        default: false, null: false
    t.string   "major"
    t.string   "team"
    t.integer  "guc_suffix"
    t.integer  "guc_prefix"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["guc_prefix"], name: "index_users_on_guc_prefix", using: :btree
  add_index "users", ["guc_suffix"], name: "index_users_on_guc_suffix", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["student"], name: "index_users_on_student", using: :btree
  add_index "users", ["team"], name: "index_users_on_team", using: :btree

  add_foreign_key "projects", "courses"
  add_foreign_key "studentships", "courses"
  add_foreign_key "studentships", "users", column: "student_id"
end
