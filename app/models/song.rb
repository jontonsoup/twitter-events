class Song < ActiveRecord::Base
    belong_to :event

    attr_accessible :artist_id, :event_id, :name
end
