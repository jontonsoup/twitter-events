  require 'rubygems'
  require 'json'
  require 'net/http'
  lib_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
  $LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

  task :playlist => :environment do
    #gets the playlist from setlist.fm and outputs it
    uri = URI('http://api.setlist.fm/rest/0.1/setlist/73de4ac1.json')
    #alternatively, via the search api
    #uri = URI('http://api.setlist.fm/rest/0.1/search/setlists.json?artistName=m83&date=29-04-2012')    
    content = Net::HTTP.get(uri)
    #puts content
    parsed_json = ActiveSupport::JSON.decode(content)
    parsed_json.class
    parsed_json['setlist']['sets']['set']['song'].each do |num|
      puts num['@name']
    end


    #gets infromation about the concert venue from songkick and outputs it
    conc = URI('http://api.songkick.com/api/3.0/events/11197508.json?apikey=9MGhAIR087t4paHA') 
    content2 = Net::HTTP.get(conc)
    #puts content2
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