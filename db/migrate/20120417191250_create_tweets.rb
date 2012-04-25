class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :text
      t.string :favorited
      t.string :in_reply_to_user_id_str
      t.string :geo
      t.string :in_reply_to_screen_name
      t.string :in_reply_to_status_id
      t.string :in_reply_to_user_id
      t.string :source
      t.integer :retweet_count
      t.string :truncated
      t.integer :id_str
      t.string :hashtags
      t.string :retweeted
      t.string :created_at
      t.integer :tweet_id
      t.string :user_mentions
      t.integer :geo_long
      t.integer :geo_lat
      t.integer :statuses_count
      t.string :country
      t.string :possibly_sensitive
      t.string :expanded_url
      t.string :verified
      t.integer :friends_count
      t.string :screenname
      t.string :user_home_location
      t.integer :id_n
      t.integer :scoreo
      t.integer :scoretw
      t.integer :scoretr
      t.integer :scoref

      t.timestamps
end
end
end
