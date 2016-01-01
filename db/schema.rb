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

ActiveRecord::Schema.define(version: 20151231221819) do

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

  create_table "reset_tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "token",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "reset_tokens", ["user_id"], name: "index_reset_tokens_on_user_id", unique: true, using: :btree

  create_table "results", force: :cascade do |t|
    t.integer  "submission_id"
    t.boolean  "compiled",        null: false
    t.text     "compiler_stderr", null: false
    t.text     "compiler_stdout", null: false
    t.integer  "grade",           null: false
    t.integer  "max_grade",       null: false
    t.boolean  "private",         null: false
    t.boolean  "success",         null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "test_suite_id"
  end

  add_index "results", ["submission_id"], name: "index_results_on_submission_id", using: :btree

  create_table "solutions", force: :cascade do |t|
    t.integer  "submission_id"
    t.binary   "code",          null: false
    t.string   "file_name",     null: false
    t.string   "mime_type",     null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "solutions", ["submission_id"], name: "index_solutions_on_submission_id", using: :btree

  create_table "studentships", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "studentships", ["course_id"], name: "index_studentships_on_course_id", using: :btree
  add_index "studentships", ["student_id"], name: "index_studentships_on_student_id", using: :btree

  create_table "submissions", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "student_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "solution_id"
  end

  add_index "submissions", ["project_id"], name: "index_submissions_on_project_id", using: :btree
  add_index "submissions", ["student_id"], name: "index_submissions_on_student_id", using: :btree

  create_table "suite_cases", force: :cascade do |t|
    t.integer  "test_suite_id"
    t.string   "name",                      null: false
    t.integer  "grade",         default: 0, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "suite_cases", ["test_suite_id"], name: "index_suite_cases_on_test_suite_id", using: :btree

  create_table "suite_codes", force: :cascade do |t|
    t.integer  "test_suite_id"
    t.binary   "code",          null: false
    t.string   "file_name",     null: false
    t.string   "mime_type",     null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "suite_codes", ["test_suite_id"], name: "index_suite_codes_on_test_suite_id", using: :btree

  create_table "team_grades", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "project_id"
    t.boolean  "private",    null: false
    t.integer  "result_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "team_grades", ["name", "project_id"], name: "index_team_grades_on_name_and_project_id", using: :btree
  add_index "team_grades", ["project_id"], name: "index_team_grades_on_project_id", using: :btree
  add_index "team_grades", ["result_id"], name: "index_team_grades_on_result_id", using: :btree

  create_table "test_cases", force: :cascade do |t|
    t.integer  "result_id"
    t.string   "name",        null: false
    t.text     "detail"
    t.text     "description"
    t.boolean  "passed",      null: false
    t.boolean  "private",     null: false
    t.integer  "grade",       null: false
    t.integer  "max_grade",   null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "test_cases", ["result_id"], name: "index_test_cases_on_result_id", using: :btree

  create_table "test_suites", force: :cascade do |t|
    t.integer  "project_id"
    t.boolean  "private",                    null: false
    t.boolean  "ready",      default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "code_id"
  end

  add_index "test_suites", ["private"], name: "index_test_suites_on_private", using: :btree
  add_index "test_suites", ["project_id"], name: "index_test_suites_on_project_id", using: :btree

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

  create_table "verification_tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "token",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "verification_tokens", ["user_id"], name: "index_verification_tokens_on_user_id", unique: true, using: :btree

  add_foreign_key "projects", "courses"
  add_foreign_key "reset_tokens", "users"
  add_foreign_key "results", "submissions"
  add_foreign_key "results", "test_suites"
  add_foreign_key "solutions", "submissions"
  add_foreign_key "studentships", "courses"
  add_foreign_key "studentships", "users", column: "student_id"
  add_foreign_key "submissions", "projects"
  add_foreign_key "submissions", "solutions"
  add_foreign_key "submissions", "users", column: "student_id"
  add_foreign_key "suite_cases", "test_suites"
  add_foreign_key "suite_codes", "test_suites"
  add_foreign_key "team_grades", "projects"
  add_foreign_key "team_grades", "results"
  add_foreign_key "test_cases", "results"
  add_foreign_key "test_suites", "projects"
  add_foreign_key "test_suites", "suite_codes", column: "code_id"
  add_foreign_key "verification_tokens", "users"
end
