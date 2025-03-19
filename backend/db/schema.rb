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

ActiveRecord::Schema[8.0].define(version: 2025_03_19_083722) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "generated_posts", force: :cascade do |t|
    t.text "content"
    t.boolean "posted"
    t.datetime "posted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "original_post_id", null: false
    t.index ["original_post_id"], name: "index_generated_posts_on_original_post_id"
  end

  create_table "keywords", force: :cascade do |t|
    t.string "word"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["word"], name: "index_keywords_on_word", unique: true
  end

  create_table "post_keywords", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "keyword_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["keyword_id"], name: "index_post_keywords_on_keyword_id"
    t.index ["post_id"], name: "index_post_keywords_on_post_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "x_post_id"
    t.text "content"
    t.string "author_username"
    t.string "author_name"
    t.integer "likes_count"
    t.datetime "posted_at"
    t.boolean "used"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["x_post_id"], name: "index_posts_on_x_post_id", unique: true
  end

  add_foreign_key "generated_posts", "posts", column: "original_post_id"
  add_foreign_key "post_keywords", "keywords"
  add_foreign_key "post_keywords", "posts"
end
