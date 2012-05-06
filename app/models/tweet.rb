class Tweet < ActiveRecord::Base
	attr_accessible :created_at, :favorited, :geo, :hashtags, :id_str, :in_reply_to_screen_name, :in_reply_to_status_id, :in_reply_to_user_id, :in_reply_to_user_id_str, :retweet_count, :retweeted, :source, :text, :truncated, :tweet_id, :user_mentions,	:geo_long, :geo_lat, :statuses_count,:country, :possibly_sensitive, :expanded_url, :verified, :friends_count, :screenname, :user_home_location, :id_n, :scoreo, :scoretw, :scoretr, :scoref, :first_pass, :second_pass, :third_pass
end
