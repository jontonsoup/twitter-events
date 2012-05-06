lib_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)
require 'rubygems'
require 'json'
require 'twitter/json_stream'
require "instagram"


task :instastream => :environment do

# All methods require authentication (either by client ID or access token).
# To get your Instagram OAuth credentials, register an app at http://instagr.am/oauth/client/register/
Instagram.configure do |config|
  config.client_id = '5eb487f496a74b00bdac591c5ac3de11'
 #config.access_token = 'bed294c7956c4d56b33ee367b746898b'
end

# Get a list of recent media at a given location, in this case, the Instagram office
 user = Instagram.user_search("mdgreenb")
 user.each do |person|
    puts person
    puts person.id
    puts Instagram.user_recent_media(person.id)
end
 #puts Instagram.user_recent_media(user.id);
end