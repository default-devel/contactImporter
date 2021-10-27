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

ActiveRecord::Schema.define(version: 2021_10_26_020203) do

  create_table "contacts", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.string "phone", null: false
    t.string "address", null: false
    t.date "date_of_birth", null: false
    t.string "franchise", null: false
    t.string "salted_cc", null: false
    t.string "last_digits", null: false
    t.boolean "is_favorite"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.bigint "upload_id", null: false
    t.index ["upload_id"], name: "index_contacts_on_upload_id"
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "pending_contacts", charset: "utf8mb4", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "phone"
    t.string "address"
    t.date "date_of_birth"
    t.string "franchise"
    t.string "salted_cc"
    t.string "last_digits"
    t.string "err_list", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.bigint "upload_id", null: false
    t.index ["upload_id"], name: "index_pending_contacts_on_upload_id"
    t.index ["user_id"], name: "index_pending_contacts_on_user_id"
  end

  create_table "upload_statuses", charset: "utf8mb4", force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "uploads", charset: "utf8mb4", force: :cascade do |t|
    t.string "uupid", default: "", null: false
    t.string "original_filename", default: "undefined", null: false
    t.integer "step", default: 0, null: false
    t.string "filename", default: "undefined", null: false
    t.string "path", default: "", null: false
    t.boolean "has_file", default: false, null: false
    t.text "file_headers", default: "''", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.bigint "upload_status_id", null: false
    t.index ["upload_status_id"], name: "index_uploads_on_upload_status_id"
    t.index ["user_id"], name: "index_uploads_on_user_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "uuid", default: "", null: false
    t.integer "pending_uploads_count", default: 0, null: false
    t.integer "pending_contacts_count", default: 0, null: false
    t.integer "contact_count", default: 0, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "contacts", "uploads"
  add_foreign_key "contacts", "users"
  add_foreign_key "pending_contacts", "uploads"
  add_foreign_key "pending_contacts", "users"
  add_foreign_key "uploads", "upload_statuses"
  add_foreign_key "uploads", "users"
end
