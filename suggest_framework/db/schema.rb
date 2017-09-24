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

ActiveRecord::Schema.define(version: 20170924082532) do

  create_table "frameworks", force: :cascade do |t|
    t.string   "framework"
    t.string   "language"
    t.integer  "community_size"
    t.string   "license"
    t.integer  "time"
    t.integer  "rps"
    t.string   "hosting"
    t.string   "databases"
    t.string   "patterns"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

end
