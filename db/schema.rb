# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_10_13_000601) do
  create_table "milestones", force: :cascade do |t|
    t.integer "project_id"
    t.string "title"
    t.text "objective"
    t.datetime "deadline"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_milestones_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "objectives"
    t.datetime "timeline"
    t.string "status", limit: 10, default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "student_assignments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_student_assignments_on_project_id"
    t.index ["user_id", "project_id"], name: "index_student_assignments_on_user_id_and_project_id", unique: true
    t.index ["user_id"], name: "index_student_assignments_on_user_id"
  end

  create_table "task_assignments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_task_assignments_on_task_id"
    t.index ["user_id"], name: "index_task_assignments_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.integer "milestone_id"
    t.string "task_name", limit: 255
    t.text "description"
    t.string "status", limit: 20, default: "Not Completed"
    t.datetime "deadline"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["milestone_id"], name: "index_tasks_on_milestone_id"
  end

  create_table "timelines", force: :cascade do |t|
    t.integer "milestone_id"
    t.integer "project_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["milestone_id"], name: "index_timelines_on_milestone_id"
    t.index ["project_id"], name: "index_timelines_on_project_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", null: false
    t.string "contact", limit: 10
    t.integer "role", default: 0
    t.string "photo", limit: 255
    t.string "provider", default: "google_oauth2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email_unique", unique: true
  end

  add_foreign_key "milestones", "projects"
  add_foreign_key "student_assignments", "projects"
  add_foreign_key "student_assignments", "users"
  add_foreign_key "task_assignments", "tasks"
  add_foreign_key "task_assignments", "users"
  add_foreign_key "tasks", "milestones"
  add_foreign_key "timelines", "milestones"
  add_foreign_key "timelines", "projects"
end
