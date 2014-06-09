require 'spec_helper.rb'

describe Movie do
  fixtures :movies 
  it 'defines fixture method' do
    movies(:starwars_movie)
  end
  it 'finds a movie by id' do
    Movie.find(1).should_not be_nil
  end
  it 'returns director when asked' do
    Movie.find(1).director.should_not be_nil
  end
  it 'sets director when asked' do
    foo = Movie.find(1)
    foo.update_attributes!(:director => "Foo")
    foo.director.should == "Foo"
  end
  it 'finds only other movies by same director' do
    returned_movies = Movie.find(1).other_movies_by_director
    returned_movies.count.should == 1 
    returned_movies.should == [movies(:thx_1138_movie)]
  end
end
