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

ActiveRecord::Schema.define(version: 20181230113328) do

  create_table "comment_likes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_comment_likes_on_comment_id", using: :btree
    t.index ["user_id"], name: "index_comment_likes_on_user_id", using: :btree
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "learning_id"
    t.text     "body",        limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "user_id"
    t.integer  "likes_count"
    t.index ["learning_id"], name: "index_comments_on_learning_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "learning_likes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "learning_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["learning_id"], name: "index_learning_likes_on_learning_id", using: :btree
    t.index ["user_id"], name: "index_learning_likes_on_user_id", using: :btree
  end

  create_table "learnings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.text     "description",                limit: 65535
    t.integer  "user_id"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.json     "images"
    t.boolean  "finish_flag",                              default: false
    t.integer  "proficiency_decrease_speed"
    t.date     "next_review_date"
    t.boolean  "public_flag"
    t.integer  "proficiency"
    t.integer  "likes_count"
    t.index ["user_id"], name: "index_learnings_on_user_id", using: :btree
  end

  create_table "reviews", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "learning_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "proficiency", default: 80
    t.index ["learning_id"], name: "index_reviews_on_learning_id", using: :btree
  end

  create_table "user_relationships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["followed_id"], name: "index_user_relationships_on_followed_id", using: :btree
    t.index ["follower_id", "followed_id"], name: "index_user_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
    t.index ["follower_id"], name: "index_user_relationships_on_follower_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",                              null: false
    t.string   "email",                             null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "avatar"
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.integer  "goal"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  add_foreign_key "comment_likes", "comments"
  add_foreign_key "comment_likes", "users"
  add_foreign_key "comments", "learnings"
  add_foreign_key "comments", "users"
  add_foreign_key "learning_likes", "learnings"
  add_foreign_key "learning_likes", "users"
  add_foreign_key "learnings", "users"
  add_foreign_key "reviews", "learnings"
end
