require 'rubygems'
require 'json'
require 'twitter/json_stream'
require 'ruby-debug'

task :newfilter => :environment do

  event = Event.find_or_create_by_name("M83 May 17")

  ###########################################
  # => Filter terms go here
  #      These should be lowercase
  #
    filter_terms = ["solo", "favorite", "excited", "set", "setlist", "cannot wait", "can't wait", "on my way", "tonight", "i'll be there", "at concert", "off to", "on sale", "sold out", "boyfriend", "girlfriend" , "boy friend", "girl friend", "free", "shirt", "waiting", "line", "opener", "friend", "backstage", "hoodie", "t-shirt", "food", "snacks", "guitar", "solo", "drums", "song", "hit", "set", "drunk", "dedicated", "sexy", "anticipation", "marry", "fitting", "perfect", "shirts", "praying", "drink", "marry", "cute", "stoned", "high", "wasted", "blitzed", "touched", "eyes", "scalped", "beer", "blunt", "smoke", "weed", "addiction", "addicted", "outfit", "gf", "bf", "cry", "crying", "tearing", "tear", "guitar pick", "beat", "drummer", "season", "voice", "scalped", "cowboy", "country", "blues", "jazz", "rockin", "balcony", "exclusive", "drumstick", "pick"]
  #
  #
  # => Negative Filter words go here
  #    These should be lowercase
  #
  #
    negative_filter_terms = ["pandora","last.fm","rdio", "spotify", "listening", "rt", "jealous", "wishing", "not going", "itunes", "wish", "not fair", "not going to be there", "soundcloud", "tomorrow", "yesterday", "radio", "commerical", "dailymotion", "dailymotion", "youtube", "last night", "rifle", "grooveshark", "getglue", "studying", "facebook statuses", "missing", "video", "not going to be there", "not going", "not there", "not gonna be there", "why am i not at", "why aren't i at", "ampz", "should be seeing", "i am not out", "not at", "kill to go see", "kill to see", "hate everyone who is going", "i would do anything to hear", "\":", ":", "i would give just about everything", "i would give just about anything", "workout song"]
  #
  ###########################################

  #tweets = Tweet.all
  event.tweets.each do |tweet|
    if tweet.source.downcase.include? 'instagram'
      tweet.first_pass = true
      tweet.save
    end

    #filter the text of the tweets
    if tweet.text.split().count < 7
       tweet.second_pass = false
    end
    if filter_terms.any? { |test_word| tweet.text.downcase.include?(test_word) }
      tweet.second_pass = true
    end
    if negative_filter_terms.any? { |test_word| tweet.text.downcase.include?(test_word) }
      tweet.second_pass = false
    end
  end
end