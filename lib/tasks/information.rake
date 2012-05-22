require 'rubygems'
require 'json'
require 'net/http'
lib_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

task :information, [:artist, :date] => :environment do |t, args|
  artist = args[:artist]
  dateOLD = args[:date]

  #need to rearrange the date
  A = dateOLD.to_s.split("-")
  date = A[2].to_s + "-" + A[1].to_s  + "-" + A[0].to_s 
  puts artist
  puts date


  #first step is to locate the artist ID
  query = 'http://api.songkick.com/api/3.0/search/artists.json?query=' + artist + '&apikey=9MGhAIR087t4paHA'
  puts query
  conc = URI(query) 
  content = Net::HTTP.get(conc)
  #puts content2
  parsed_json = ActiveSupport::JSON.decode(content)
  id = parsed_json["resultsPage"]["results"]["artist"][0]["id"]
  puts id


  #open the event for writing
  event = Event.find_or_create_by_name("M83 5/20")


  #next step is to use the artist id to loop up all events and locate the one one the date you;re looking for
  pass = false
  page = 1
  concertID = ""
  while pass == false
    artistQuery = 'http://api.songkick.com/api/3.0/artists/' + id.to_s + '/gigography.json?apikey=9MGhAIR087t4paHA&page=' + page.to_s
    puts artistQuery
    conc2 = URI(artistQuery) 
    content2 = Net::HTTP.get(conc2)
    #puts content2
    parsed_json2 = ActiveSupport::JSON.decode(content2)
    parsed_json2["resultsPage"]["results"]["event"].each do |num|
      if num["start"]["date"] == date
        puts "Concert found!!!"
        concertID = num["id"]
        puts concertID
        pass = true
      end
    end
    page += 1
  end

  #last step is to take the event id and pull the relavent information
  eventQuery = 'http://api.songkick.com/api/3.0/events/' + concertID.to_s + '.json?apikey=9MGhAIR087t4paHA'
  puts eventQuery
  conc3 = URI(eventQuery) 
  content3 = Net::HTTP.get(conc3)
  parsed_json3 = ActiveSupport::JSON.decode(content3)
  puts parsed_json3
  event.long = parsed_json3["resultsPage"]["results"]["event"]["location"]["lng"]
  event.lat = parsed_json3["resultsPage"]["results"]["event"]["location"]["lat"]
  capacity = parsed_json3["resultsPage"]["results"]["event"]["venue"]["capacity"]
  event.artist = artist
  event.location = parsed_json3["resultsPage"]["results"]["event"]["venue"]["displayName"]
  date = parsed_json3["resultsPage"]["results"]["event"]["start"]["date"]
  time = parsed_json3["resultsPage"]["results"]["event"]["start"]["time"]
  puts capacity  
  puts date 
  puts time   
  event.save

end