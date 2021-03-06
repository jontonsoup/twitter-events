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

ActiveRecord::Schema.define(:version => 20120529033005) do

  create_table "categories", :force => true do |t|
    t.string "name"
  end

  create_table "categories_tweets", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "tweet_id"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.float    "lat"
    t.float    "long"
    t.string   "location"
    t.string   "artist"
    t.string   "opener"
    t.integer  "number_of_people"
    t.boolean  "sold_out"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "songs", :force => true do |t|
    t.string   "name"
    t.integer  "event_id"
    t.integer  "artist_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tweets", :force => true do |t|
    t.string   "text"
    t.string   "favorited"
    t.string   "in_reply_to_user_id_str"
    t.string   "geo"
    t.string   "in_reply_to_screen_name"
    t.string   "in_reply_to_status_id"
    t.string   "in_reply_to_user_id"
    t.string   "source"
    t.integer  "retweet_count"
    t.string   "truncated"
    t.integer  "id_str"
    t.string   "hashtags"
    t.string   "retweeted"
    t.string   "created_at",              :null => false
    t.integer  "tweet_id"
    t.string   "user_mentions"
    t.integer  "geo_long"
    t.integer  "geo_lat"
    t.integer  "statuses_count"
    t.string   "country"
    t.string   "possibly_sensitive"
    t.string   "expanded_url"
    t.string   "verified"
    t.integer  "friends_count"
    t.string   "screenname"
    t.string   "user_home_location"
    t.integer  "id_n"
    t.integer  "scoreo"
    t.integer  "scoretw"
    t.integer  "scoretr"
    t.integer  "scoref"
    t.boolean  "first_pass"
    t.boolean  "second_pass"
    t.boolean  "third_pass"
    t.string   "image"
    t.integer  "event_id"
    t.datetime "updated_at",              :null => false
  end

end
