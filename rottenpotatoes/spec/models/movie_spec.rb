require 'spec_helper.rb'

describe Movie do
  fixtures :movies 
  it 'defines fixture method' do
    movies(:starwars_movie)
  end
  
#  describe 'find a movie by id' do
#    puts(Movie.first.inspect)
#    Movie.find(1).should_not be_empty
#  end
end
