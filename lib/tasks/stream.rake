  require 'rubygems'
  require 'json'
  require 'twitter/json_stream'
  lib_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
  $LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

  task :stream => :environment do
    EventMachine::run {
      stream = Twitter::JSONStream.connect(
        :path    => '/1/statuses/filter.json',
        :auth    => 'nutevents:northwestern',
        :method  => 'POST',
        :content => "track=barack%20obama,north%20korea"
        )

      stream.each_item do |item|
        #$stdout.print "#{item}\n,"
        #$stdout.flush
        parsed_json = ActiveSupport::JSON.decode(item)

  # This is for saving to the rails database
  puts parsed_json["text"]
  Tweet.create({
    :text => parsed_json["text"],
    :favorited => parsed_json["favorited"],
    :in_reply_to_user_id_str => parsed_json["in_reply_to_user_id_str"],
    #:geo => "null",
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
      :country => parsed_json["user"]["location"]
     #not real? :possibly_sensitive => parsed_json["possibly_sensitive"],
     # :url => parsed_json["user"]["url"],
     # :verified => parsed_json["user"]["verified"]
     # :friends_count => parsed_json["user"]["friends_count"],
     # :screenname => parsed_json["screenname"],
    # :user_home_location => parsed_json["user_home_location"]
      })
puts "\n"
#puts parsed_json
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