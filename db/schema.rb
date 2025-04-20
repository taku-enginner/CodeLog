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

ActiveRecord::Schema[7.2].define(version: 2025_04_20_054601) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "annotation_tags", force: :cascade do |t|
    t.bigint "annotation_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["annotation_id"], name: "index_annotation_tags_on_annotation_id"
    t.index ["tag_id"], name: "index_annotation_tags_on_tag_id"
  end

  create_table "annotations", force: :cascade do |t|
    t.bigint "repository_id", null: false
    t.bigint "user_id", null: false
    t.string "file_path"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tags"
    t.string "file_sha"
    t.index ["repository_id"], name: "index_annotations_on_repository_id"
    t.index ["user_id"], name: "index_annotations_on_user_id"
  end

  create_table "repositories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.string "full_name"
    t.string "github_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_repositories_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "annotation_tags", "annotations"
  add_foreign_key "annotation_tags", "tags"
  add_foreign_key "annotations", "repositories"
  add_foreign_key "annotations", "users"
  add_foreign_key "repositories", "users"
end
