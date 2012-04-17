require 'rubygems'
require 'json'
require 'twitter/json_stream'
lib_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)


# EventMachine::run {
#   stream = Twitter::JSONStream.connect(
#     :path    => '/1/statuses/sample.json',
#     :auth    => 'nutevents:northwestern',
#     :method  => 'GET',
#     #:content => 'track=ankees,yanks,nyy,bombers'
#   )

puts "{'tweets': ["

EventMachine::run {
  stream = Twitter::JSONStream.connect(
    :path    => '/1/statuses/filter.json',
    :auth    => 'nutevents:northwestern',
    :method  => 'POST',
    :content => 'track=The Riviera, fray, The Fray, Fray, Riv, The Riv, riviera, Jessie Baylin, Baylin, How to Save a Life, Isaac Slade, Joe King,Dave Welsh, Ben Wysocki, Jeremy McCoy, Wysocki, TheFray, TheRiviera, TheRiv, JessieBaylin'
    )

  stream.each_item do |item|
    $stdout.print "#{item},"
    $stdout.flush

  # This is for saving to the rails database
  #   Tweet.create!({
  #     :text => "",
  #     :favorited => "",
  #     :in_reply_to_user_id_str => "",
  #     :geo => "",
  #     :in_reply_to_screen_name => "",
  #     :in_reply_to_status_id => "",
  #     :in_reply_to_user_id => "",
  #     :source => "",
  #     :retweet_count => "",
  #     :truncated => "",
  #     :id_str => "",
  #     :hashtags => "",
  #     :retweeted => "",
  #     :created_at => "",
  #     :tweet_id => "",
  #     :user_mentions => ""
  #     })
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
#puts "The event loop has ended"