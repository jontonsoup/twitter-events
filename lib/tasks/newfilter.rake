require 'rubygems'
require 'json'
require 'twitter/json_stream'
require 'ruby-debug'

task :newfilter => :environment do

  event = Event.find_or_create_by_name("Best Coast 6/3")

  ###########################################
  #      Filter terms go here
  #      These should be lowercase
  #
  instruments = ["guitar", "drums",  "guitar pick", "drummer", "drumstick", "pick", "bass", "bassist"]

  emotion = ["cry", "crying", "tearing", "tear", "never forget"]

  onway = ["off to", "here i come", "here we come", "on my way", "line", "going to"]

  anticipation = ["cannot wait", "can't wait", "excited", "i'll be there", "anticipation", "waiting", "looking forward", "praying"]

  description = ["concert","tonight", "sold out", "solo", "favorite", "outfit", "exclusive", "musical experience", "scalped", "rockin", "balcony", "front row", "row", "front","encore", "voice", "cowboy", "set", "setlist", "scalped", "backstage", "opener", "at concert", "set", "fitting", "chills", "dancing", "duet", "met", "unreal night"]

  drugs = ["blunt", "smoke", "weed", "stoned", "high", "rolling"]

  drinking = ["drink", "drunk", "beer", "wasted", "blitzed"]

  relationship = ["boyfriend", "girlfriend" , "boy friend", "girl friend", "gf", "bf", "friend", "dedicated"]

  lust = ["sexy", "marry", "cute", "addiction", "addicted", "touched", "eyes", "marry"]

  items = ["on sale", "free", "shirt","hoodie", "t-shirt", "food", "snacks", "shirts", "tshirt"]

  after =  ["just saw", "just watched"]

  #
  #
  # => Negative Filter words go here
  #    These should be lowercase
  #
  #
  negative_filter_terms = ["pandora","last.fm","rdio", "spotify", "listening", "rt", "jealous", "wishing", "not going", "itunes", "wish", "not fair", "not going to be there", "soundcloud", "tomorrow", "yesterday", "radio", "commerical", "dailymotion", "dailymotion", "youtube", "last night", "rifle", "grooveshark", "getglue", "studying", "facebook statuses", "missing", "video", "not going to be there", "not going", "not there", "not gonna be there", "why am i not at", "why aren't i at", "ampz", "should be seeing", "i am not out", "not at", "kill to go see", "kill to see", "hate everyone who is going", "i would do anything to hear", "\":", ":", "i would give just about everything", "i would give just about anything", "workout song", "ipod", "workout", "fuck", "shit", "fucking", "fuckin", "fucker", "fucked", "shat", "shitty", "shitting","exfm","free track","download","tomorrow", "i couldn't go", "next week", "feat", "listen", "was asking", "imagine", "xoxo", "link", "preview", "la", "el","song", "on", "gusta", "heard", "fave", "lol", "#10peopleIHaveSeenLive", "#10bandsilike"]
  #
  ##########################################

  event.tweets.each do |tweet|
    tweet.first_pass = false
    tweet.second_pass = false

    begin
      if tweet.source.downcase.include? 'instagram'
        tweet.first_pass = true
        #tweet.second_pass = true
        tweet.save
        puts tweet.text
      end
    rescue
    end

    #filter the text of the tweets
    if tweet.text.split().count < 5
      tweet.second_pass = false
    end

    if instruments.any? { |test_word| tweet.text.downcase.include?(test_word) }

      if tweet.second_pass == false or tweet.second_pass == nil
        tweet.categories.create(:name => "Instruments")
      end
      tweet.second_pass = true

    elsif emotion.any? { |test_word| tweet.text.downcase.include?(test_word) }

      if tweet.second_pass == false or tweet.second_pass == nil
        tweet.categories.create(:name =>"Emotions")
      end
      tweet.second_pass = true

    elsif onway.any? { |test_word| tweet.text.downcase.include?(test_word) }

      if tweet.second_pass == false or tweet.second_pass == nil
        tweet.categories.create(:name =>"On Way To Concert")
      end
      tweet.second_pass = true

    elsif anticipation.any? { |test_word| tweet.text.downcase.include?(test_word) }

      if tweet.second_pass == false or tweet.second_pass == nil
        tweet.categories.create(:name =>"Anticipation")
      end
      tweet.second_pass = true

    elsif description.any? { |test_word| tweet.text.downcase.include?(test_word) }

      if tweet.second_pass == false or tweet.second_pass == nil
        tweet.categories.create(:name =>"Atmosphere")
      end
      tweet.second_pass = true

    elsif drugs.any? { |test_word| tweet.text.downcase.include?(test_word) }

      if tweet.second_pass == false or tweet.second_pass == nil
        tweet.categories.create(:name =>"Drugs")
      end
      tweet.second_pass = true

    elsif drinking.any? { |test_word| tweet.text.downcase.include?(test_word) }
      if tweet.second_pass == false or tweet.second_pass == nil
        tweet.categories.create(:name =>"Drinking")
      end
      tweet.second_pass = true

    elsif relationship.any? { |test_word| tweet.text.downcase.include?(test_word) }
      if tweet.second_pass == false or tweet.second_pass == nil
        tweet.categories.create(:name =>"Relationship")
      end
      tweet.second_pass = true

    elsif lust.any? { |test_word| tweet.text.downcase.include?(test_word) }
      if tweet.second_pass == false or tweet.second_pass == nil
        tweet.categories.create(:name =>"Lust")
      end
      tweet.second_pass = true


    elsif items.any? { |test_word| tweet.text.downcase.include?(test_word) }
      if tweet.second_pass == false or tweet.second_pass == nil
        tweet.categories.create(:name =>"Items")
      end
      tweet.second_pass = true

    elsif after.any? { |test_word| tweet.text.downcase.include?(test_word) }
      if tweet.second_pass == false or tweet.second_pass == nil
        tweet.categories.create(:name =>"After The Concert")
      end
      tweet.second_pass = true
    end


    if negative_filter_terms.any? { |test_word| tweet.text.downcase.include?(test_word) }
      tweet.second_pass = false
    end

    #tweet.text = tweet.text.gsub(/#\S+/, '')
    #tweet.text = tweet.text.gsub(/@/, '')
    #tweet.text = tweet.text.gsub(/(http|https)\:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?/, '')
      tweet.second_pass = false
    end
    #tweet.save
  end

#puts "The event loop has ended"