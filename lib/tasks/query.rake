  require 'rubygems'
  require 'json'
  require 'net/http'
  lib_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
  $LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

  task :query => :environment do
    uri = URI('http://developer.echonest.com/api/v4/song/search?api_key=WEUXIKHF3BJV6BNNA&artist=m83&sort=song_hotttnesss-desc&results=10')
    content = Net::HTTP.get(uri)
    puts content
    puts "\n TESTING"
    parsed_json = ActiveSupport::JSON.decode(content)
    parsed_json.class
    num = $10
    parsed_json["response"]["songs"].each do |num|
      #puts parsed_json["response"]["songs"]
      puts num["title"]
      puts num["id"]
    end

    conc = URI('http://api.songkick.com/api/3.0/events/11197508.json?apikey=9MGhAIR087t4paHA') 
    content2 = Net::HTTP.get(conc)
    puts content2
    parsed_json2 = ActiveSupport::JSON.decode(content2)
    lng = parsed_json2["resultsPage"]["results"]["event"]["location"]["lng"]
    lat = parsed_json2["resultsPage"]["results"]["event"]["location"]["lat"]
    capacity = parsed_json2["resultsPage"]["results"]["event"]["venue"]["capacity"]
    eInfo = parsed_json2["resultsPage"]["results"]["event"]["displayName"]
    date = parsed_json2["resultsPage"]["results"]["event"]["start"]["date"]
    time = parsed_json2["resultsPage"]["results"]["event"]["start"]["time"]
    puts lng #
    puts lat 
    puts capacity 
    puts eInfo 
    puts date 
    puts time
    #parsed_json["response"]["songs"].each |num| "title"


  end