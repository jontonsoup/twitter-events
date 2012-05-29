require 'rubygems'
require 'json'
require 'twitter/json_stream'
require 'ruby-debug'
lib_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

########################################################
#
# => Make sure you fill out all the required fields
#
#
#
###########################################################


task :stream => :environment do
  EventMachine::run {
    stream = Twitter::JSONStream.connect(
      :path    => '/1/statuses/filter.json',

      #########################################
      #     Enter Twitter Account Here
      :auth    => 'nutevents1:northwestern',
      #
      #
      ##########################################

      :method  => 'POST',

      ######################################
      #   Enter Search Terms Here
      #
      :content => "track=foster%20the%20people,The%20Kooks,Kimbra,Rumsey%20Playfield,Mark%20Foster"
      #
      ######################################

      )
    ###########################################
    #      Add the even name here
    event = Event.find_or_create_by_name("Foster The People")
    #
    #
    ###########################################
    puts "\n\n\n" + "You are parsing event: " + event.name + "\n\n\n"

    ###########################################
    #      Filter terms go here
    #      These should be lowercase
    #
    instruments = ["guitar", "drums",  "guitar pick", "beat", "drummer", "drumstick", "pick"]

    emotion = ["cry", "crying", "tearing", "tear"]

    onway = ["off to", "here i come", "here we come", "on my way", "line"]

    anticipation = ["cannot wait", "can't wait", "excited", "i'll be there", "anticipation", "waiting"]

    description = ["tonight", "sold out", "solo", "favorite", "outfit", "exclusive", "musical experience", "experience", "scalped", "perfect", "rockin", "balcony", " front row", "row", "front","encore", "voice", "cowboy", "country", "blues", "jazz", "set", "setlist", "scalped", "backstage", "opener", "at concert", "season", "hit", "set", "fitting","praying","song"]

    drugs = ["blunt", "smoke", "weed", "stoned", "high", "rolling"]

    drinking = ["drink", "drunk", "beer", "wasted", "blitzed"]

    relationship = ["boyfriend", "girlfriend" , "boy friend", "girl friend", "gf", "bf", "friend", "dedicated"]

    lust = ["sexy", "marry", "cute", "addiction", "addicted", "touched", "eyes", "marry"]

    items = ["on sale", "free", "shirt","hoodie", "t-shirt", "food", "snacks", "shirts"]

    #
    #
    # => Negative Filter words go here
    #    These should be lowercase
    #
    #
    negative_filter_terms = ["pandora","last.fm","rdio", "spotify", "listening", "rt", "jealous", "wishing", "not going", "itunes", "wish", "not fair", "not going to be there", "soundcloud", "tomorrow", "yesterday", "radio", "commerical", "dailymotion", "dailymotion", "youtube", "last night", "rifle", "grooveshark", "getglue", "studying", "facebook statuses", "missing", "video", "not going to be there", "not going", "not there", "not gonna be there", "why am i not at", "why aren't i at", "ampz", "should be seeing", "i am not out", "not at", "kill to go see", "kill to see", "hate everyone who is going", "i would do anything to hear", "\":", ":", "i would give just about everything", "i would give just about anything", "workout song", "ipod", "workout", "fuck", "shit", "fucking", "fuckin", "fucker", "fucked", "shat", "shitty", "shitting","exfm","free track","download","tomorrow"]
    #
    ###########################################


    #get the twiter stream
    stream.each_item do |item|
      #$stdout.print "#{item}\n,"
      #$stdout.flush
      parsed_json = ActiveSupport::JSON.decode(item)

      # This is for saving to the rails database
      expanded = nil
      begin
        expanded = parsed_json["entities"]["urls"][0]["expanded_url"]
      rescue
      end
      begin
        event.tweets.create({
          :text => parsed_json["text"],
          :favorited => parsed_json["favorited"],
          :in_reply_to_user_id_str => parsed_json["in_reply_to_user_id_str"],
          #:geo => "null",an
          :in_reply_to_screen_name => parsed_json["in_reply_to_screen_name"],
          :in_reply_to_status_id => parsed_json["in_reply_to_status_id"],
          :in_reply_to_user_id => parsed_json["in_reply_to_user_id"],
          :source => parsed_json["source"],
          :retweet_count => parsed_json["retweet_count"],
          :truncated => parsed_json["truncated"],
          #:id_str => parsed_json["id_str"],
          #:hashtags => parsed_json["entities"]["hashtags"][1],
          :retweeted => parsed_json["retweeted"],
          :created_at => parsed_json["created_at"],
          #:tweet_id => parsed_json["id"],
          #:user_mentions => parsed_json["user_mentions"],
          #:geo_long => parsed_json["geo_long"],
          #:geo_lat => parsed_json["geo_lat"],
          :statuses_count => parsed_json["user"]["statuses_count"],
          :country => parsed_json["user"]["location"],
          #not real? :possibly_sensitive => parsed_json["possibly_sensitive"],
          :expanded_url => expanded,
          :verified => parsed_json["user"]["verified"],
          :friends_count => parsed_json["user"]["friends_count"],
          :screenname => parsed_json["screenname"]
          # :user_home_location => parsed_json["user_home_location"]
          })
rescue
end

      #parse instagram and strip bad data from tweets
      tweets = Tweet.where("first_pass is null OR second_pass is null")
      tweets.each do |tweet|

        begin
          if tweet.source.downcase.include? 'instagram'

            tweet.first_pass = true
            tweet.save
            puts tweet.text

            begin
              doc = Nokogiri::HTML(open(tweet.expanded_url))

              #get image path from instagram document
              doc.xpath("//img[@class='photo']/@src").each do |img|
                puts img
                Tweet.update(tweet.id, :image => img.to_s)
              end
            rescue
            end
          end
        rescue
        end

        #filter the text of the tweets
        if tweet.text.split().count < 7
          tweet.second_pass = false
        end

        if instruments.any? { |test_word| tweet.text.downcase.include?(test_word) }

          if tweet.second_pass == false or tweet.second_pass == nil
            tweet.categories.create(:name => "Instruments")
          end
          tweet.second_pass = true
        end

        if emotion.any? { |test_word| tweet.text.downcase.include?(test_word) }

          if tweet.second_pass == false or tweet.second_pass == nil
            tweet.categories.create(:name =>"Emotions")
          end
          tweet.second_pass = true
        end

        if onway.any? { |test_word| tweet.text.downcase.include?(test_word) }

          if tweet.second_pass == false or tweet.second_pass == nil
            tweet.categories.create(:name =>"On Way To Concert")
          end
          tweet.second_pass = true
        end

        if anticipation.any? { |test_word| tweet.text.downcase.include?(test_word) }

          if tweet.second_pass == false or tweet.second_pass == nil
            tweet.categories.create(:name =>"Anticipation")
          end
          tweet.second_pass = true
        end

        if description.any? { |test_word| tweet.text.downcase.include?(test_word) }

          if tweet.second_pass == false or tweet.second_pass == nil
            tweet.categories.create(:name =>"Description")
          end
          tweet.second_pass = true
        end

        if drugs.any? { |test_word| tweet.text.downcase.include?(test_word) }

          if tweet.second_pass == false or tweet.second_pass == nil
            tweet.categories.create(:name =>"Drugs")
          end
          tweet.second_pass = true
        end

        if drinking.any? { |test_word| tweet.text.downcase.include?(test_word) }
          if tweet.second_pass == false or tweet.second_pass == nil
            tweet.categories.create(:name =>"Drinking")
          end
          tweet.second_pass = true
        end

        if relationship.any? { |test_word| tweet.text.downcase.include?(test_word) }
          if tweet.second_pass == false or tweet.second_pass == nil
            tweet.categories.create(:name =>"Relationship")
          end
          tweet.second_pass = true
        end

        if lust.any? { |test_word| tweet.text.downcase.include?(test_word) }
          if tweet.second_pass == false or tweet.second_pass == nil
            tweet.categories.create(:name =>"Lust")
          end
          tweet.second_pass = true
        end


        if items.any? { |test_word| tweet.text.downcase.include?(test_word) }
          if tweet.second_pass == false or tweet.second_pass == nil
            tweet.categories.create(:name =>"Items")
          end
          tweet.second_pass = true
        end

        if negative_filter_terms.any? { |test_word| tweet.text.downcase.include?(test_word) }
          tweet.second_pass = false
        end

        tweet.text = tweet.text.gsub(/#\S+/, '')
        tweet.text = tweet.text.gsub(/@\S+/, '')
        tweet.text = tweet.text.gsub(/(http|https)\:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?/, '')
        if tweet.text.split().count < 11
          tweet.second_pass = false
        end
        tweet.save
      end

    end

    stream.on_error do |message|
      #$stdout.print "error: #{message}\n"
      #$stdout.flush
    end

    stream.on_reconnect do |timeout, retries|
      #$stdout.print "reconnecting in: #{timeout} seconds\n"
      #$stdout.flush
    end

    stream.on_max_reconnects do |timeout, retries|
      #stdout.print "Failed after #{retries} failed reconnects\n"
      #$stdout.flush
    end

    trap('TERM') {
      stream.stop
      EventMachine.stop if EventMachine.reactor_running?
    }
  }

end
#puts "The event loop has ended"
