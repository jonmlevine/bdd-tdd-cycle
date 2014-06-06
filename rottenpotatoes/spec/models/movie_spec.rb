require 'spec_helper.rb'

describe Movie do
  fixtures :movies 
  it 'defines fixture method' do
    movies(:starwars_movie)
  end
  it 'finds a movie by id' do
    Movie.find(1).should_not be_nil
  end
  it 'finds only other movies by same director' do
    Movie.find(1).other_movies_by_director.count.should == 1 
  end
end
