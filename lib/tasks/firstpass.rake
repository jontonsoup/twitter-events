require 'rubygems'
require 'json'
require 'twitter/json_stream'
require 'nokogiri'
require 'open-uri'

lib_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

task :firstpass => :environment do
  tweets = Tweet.all
  tweets.each do |tweet|
    if tweet.source.downcase.include? 'instagram'
      tweet.first_pass = true
      puts tweet.text

      doc = Nokogiri::HTML(open(tweet.expanded_url))

      # Do funky things with it using Nokogiri::XML::Node methods...

      ####
      # Search for nodes by css
      doc.css('h3.r a.l').each do |link|
        puts link.content
      end
    end
  end
end
