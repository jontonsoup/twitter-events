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
      :content => "track=beach%20boys,chicago%20theater,brian%20wilson,glenn%20campbell,dennis%20wilson,al%20jardine,bruce%20johnston,david%20marks"
      #
      ######################################

      )
    ###########################################
    #      Add the even name here
    event = Event.find_or_create_by_name("The Beach Boys 5/22")
    #
    #
    ###########################################
    puts "\n\n\n" + "You are parsing event: " + event.name + "\n\n\n"

     ###########################################
    #      Filter terms go here
    #      These should be lowercase
    #
    filter_terms = ["solo", "favorite", "excited", "set", "setlist", "cannot wait", "can't wait", "on my way", "tonight", "i'll be there", "at concert", "off to", "on sale", "sold out", "boyfriend", "girlfriend" , "boy friend", "girl friend", "free", "shirt", "waiting", "line", "opener", "friend", "backstage", "hoodie", "t-shirt", "food", "snacks", "guitar", "solo", "drums", "song", "hit", "set", "drunk", "dedicated", "sexy", "anticipation", "marry", "fitting", "perfect", "shirts", "praying", "drink", "marry", "cute", "stoned", "high", "wasted", "blitzed", "touched", "eyes", "scalped", "beer", "blunt", "smoke", "weed", "addiction", "addicted", "outfit", "gf", "bf", "cry", "crying", "tearing", "tear", "guitar pick", "beat", "drummer", "season", "voice", "scalped", "cowboy", "country", "blues", "jazz", "rockin", "balcony", "exclusive", "drumstick", "pick", "here i come", "here we come", "musical experience", "experience", " front row", "row", "front","encore"]
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
