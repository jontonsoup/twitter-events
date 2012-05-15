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

uri = URI.parse("https://api.instagram.com/v1/locations/2082352/media/recent?access_token=3970109.5eb487f.379b03c4a5254d6f80a49fc42f18db37")
   http = Net::HTTP.new(uri.host, uri.port)
   http.use_ssl = true
   http.verify_mode = OpenSSL::SSL::VERIFY_NONE
   request = Net::HTTP::Get.new(uri.request_uri)

   json_output = http.request(request)
   puts json_output
   IGData = JSON.parse(json_output.body)
   
   #take the instagram data and push it into our "tweet " structure
   #set first_pass to true to indicate that it has a photo
   IGData["data"].each do |num|
   		puts num["location"]["name"]
    	puts num["filter"]
    	Tweet.create({
          :text => num["caption"]["text"],
          :image => num["images"]["standard_resolution"]["url"],
          :first_pass => true
      	})
    end


 #puts Instagram.user_recent_media(user.id);
end