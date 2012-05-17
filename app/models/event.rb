class Event < ActiveRecord::Base

    has_many :tweets
    has_many :songs

  attr_accessible :artist, :lat, :location, :long, :name, :number_of_people, :opener, :sold_out
end
