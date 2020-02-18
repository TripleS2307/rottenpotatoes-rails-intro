class Movie < ActiveRecord::Base
    attr_accessible :title, :rating, :release_date
    @@all_ratings = ['G', 'PG', 'PG-13', 'R']
    def self.all_ratings
        @@all_ratings
    end
end