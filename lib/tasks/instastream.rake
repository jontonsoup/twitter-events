lib_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)
require 'rubygems'
require 'json'
require 'twitter/json_stream'
require 'instagram'
require 'net/http'
require 'net/https'

task :instastream => :environment do

  #pulls down instagram data from location nubmer 2082352 (madison square garden) into JSON ... 
  #still need to parse it... 

  #the Ocation field is where the stream gets pulled from, we might want to use a search instead of a 
  #location tag or a combination of both

  minDate = 1336798800
  maxDate = 1338798800
  ocation = "https://api.instagram.com/v1/locations/2082352/media/recent?access_token=3970109.5eb487f.379b03c4a5254d6f80a49fc42f18db37"
  #tweets.getIGData(igLocURI)
  reachedEnd = false
  while reachedEnd == false
    uri = URI.parse(ocation)
    http = Net::HTTP.new(uri.host, uri.port)
     http.use_ssl = true
     http.verify_mode = OpenSSL::SSL::VERIFY_NONE
     request = Net::HTTP::Get.new(uri.request_uri)

     json_output = http.request(request)
     puts json_output
     igData = JSON.parse(json_output.body)
     
     #take the instagram data and push it into our "tweet " structure
     #set first_pass to true to indicate that it has a photo

     igData["data"].each do |num|
        puts num["location"]["name"]
        puts num["filter"]
        puts num
        if num["created_time"].to_i > minDate
          Tweet.create({
                #needs to check if text is empty or not
                #:text => num["caption"]["text"],
                :image => num["images"]["standard_resolution"]["url"],
                :first_pass => true 
              })
        end
        if num["created_time"].to_i < minDate
          puts "END"
          reachedEnd = true
        end
      end
      puts igData["pagination"]["next_url"]
      ocation = igData["pagination"]["next_url"]
    end
   #puts Instagram.user_recent_media(user.id);
end