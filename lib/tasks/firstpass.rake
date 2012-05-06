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
end
end
