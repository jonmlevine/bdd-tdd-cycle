class Movie < ActiveRecord::Base

  attr_accessible :title, :rating, :description, :release_date, :director

  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  def other_movies_by_director
    if self.director != nil && self.director != "" then
      return Movie.where("id <> :id and director = :director", {id: self.id, director: self.director})
    else
      return nil
    end
  end
end

