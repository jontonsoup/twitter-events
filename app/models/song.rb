class Song < ActiveRecord::Base
    belongs_to :event

    attr_accessible :artist_id, :event_id, :name
end
