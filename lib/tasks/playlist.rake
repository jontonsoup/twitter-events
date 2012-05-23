require 'rubygems'
require 'json'
require 'net/http'
lib_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

task :playlist, [:artist, :date] => :environment do |t, args|
  #gets the playlist from setlist.fm and outputs it
  artist = args[:artist]
  date = args[:date]
  puts artist
  puts date
  artist2 = URI.escape(artist)
  #'http://api.setlist.fm/rest/0.1/setlist/73de4ac1.json'
  query = 'http://api.setlist.fm/rest/0.1/search/setlists.json?artistName=' + artist2 + '&date=' + date
  puts query
  uri = URI(query)
  content = Net::HTTP.get(uri)

  eventName = "The Beach Boys 5/22"

  event = Event.find_or_create_by_name(eventName)

  #takes two arguments, date and artist (date in DD-MM-YYYY format) and outputs the most current version of the setlist
  parsed_json = ActiveSupport::JSON.decode(content)
  parsed_json.class
  puts parsed_json['setlists']['@total'].to_i
  if parsed_json['setlists']['@total'].to_i > 1
    parsed_json['setlists']['setlist'].each_with_index do |num, index|
      if index == parsed_json['setlists']['setlist'].size - 1
        num['sets']['set']['song'].each do |num2|
          puts num2['@name']
          event.songs.create({
          :name => num2['@name']
          })
        end
      end
    end
  end
  if parsed_json['setlists']['@total'].to_i == 1
    parsed_json['setlists']['setlist']['sets']['set'].each do |num2|
      num2['song'].each do |num3|
        puts num3['@name']
        event.songs.create({
          :name => num3['@name']      
          })
      end
    end
  end

end