class Category < ActiveRecord::Base
    has_and_belongs_to_many :tweets
    attr_accessible :name
end
