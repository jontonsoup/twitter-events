lib_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)
require 'rubygems'
require 'json'
require 'net/http'
require 'ym4r'

include Ym4r::GoogleMaps
task :locations => :environment do

  #just need now to save the location data to the latitude and longitude fields
  tweets = Tweet.where("country is not null ")
  tweets.each do |tweet|
    results = Geocoding::get(tweet.country)
    puts results[0].latlon
    if results.status == Geocoding::GEO_SUCCESS
      tweet.favorited = results[0].latlon
      tweet.save
    elsif 
      tweet.favorited = "nil"
    end
      
      
    #[0]["latitude"]
  end
end