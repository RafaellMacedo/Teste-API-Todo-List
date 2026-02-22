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

ActiveRecord::Schema[8.1].define(version: 2026_02_22_175849) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "items_dependencies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "depends_on"
    t.bigint "list_item_id", null: false
    t.datetime "updated_at", null: false
    t.index ["list_item_id"], name: "index_items_dependencies_on_list_item_id"
  end

  create_table "list_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "data"
    t.string "titulo"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "items_dependencies", "list_items"
  add_foreign_key "items_dependencies", "list_items", column: "depends_on", on_delete: :cascade
end
