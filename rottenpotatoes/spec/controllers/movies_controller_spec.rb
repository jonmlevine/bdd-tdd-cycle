require 'spec_helper.rb'

describe MoviesController do
  describe 'Show a Movie' do
    it 'should find a movie and switch to the show page' do
      fake_result = [double('movie_orig')]
      Movie.should_receive(:find).with("1")
      get :show, :id => 1
      response.should render_template('show')
    end
  end
  
  describe 'Find Other Movies by Same Director' do
    context 'given a movie with a known director' do
      let (:fake_movie) {double("movie", :director=>'George Lucas')}
      let (:fake_results) {[double("movieout1"), double("movieout2")]}
      it 'should call the model method that searches for movies by same director' do
        Movie.should_receive(:find).with("1").and_return(fake_movie)
        fake_movie.should_receive(:other_movies_by_director).and_return(fake_results)
        get :similar, :id => 1
      end
      it 'should select the Similar template for rendering' do
        fake_movie.stub(:other_movies_by_director)
        get :similar, :id => 1
        response.should render_template('similar')
      end
      it 'should make the model other movies search results available to that template' do
        Movie.should_receive(:find).with("1").and_return(fake_movie)
        fake_movie.stub(:other_movies_by_director).and_return(fake_results)
        get :similar, :id => 1
        assigns(:movies).should == fake_results
      end
    end
    context 'given a movie without a known director' do
      let (:fake_movie) {double("movie", :title => "A Movie", :director => nil)}
      it 'should call the model method that searches for movies by same director and not fail' do
        Movie.should_receive(:find).with("1").and_return(fake_movie)
        get :similar, :id => 1
      end
      it 'should not select the Similar template for rendering' do
        Movie.should_receive(:find).with("1").and_return(fake_movie)
        get :similar, :id => 1
        response.should_not render_template('similar')
      end
      it 'should set the flash message' do
        Movie.should_receive(:find).with("1").and_return(fake_movie)
        get :similar, :id => 1
        flash[:notice].should eq("'#{fake_movie.title}' has no director info")
      end
    end
  end
end
