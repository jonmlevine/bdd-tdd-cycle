require 'spec_helper.rb'

describe MoviesController do
  describe 'Show a Movie' do
    it 'should find a movie and switch to the show page' do
      Movie.should_receive(:find).with("1")
      get :show, :id => 1
      response.should render_template('show')
    end
  end
  
  describe 'Show New Movie Page' do
    it 'should navigate to the new movie page' do
      get :new
      response.should render_template('new')
    end
  end
  
  describe 'Create a Movie' do
    let (:fake_movie) {double("movie", :id => 99, :title => "A Jon's Life")}    
    it 'should accept input and insert' do
      Movie.should_receive(:create!).with("id" => "99", "title" => "A Jon's Life").and_return(fake_movie)
      post :create, :movie => {:id => 99, :title => "A Jon's Life"}
    end
    it 'should display a nice message' do
      Movie.should_receive(:create!).with("id" => "99", "title" => "A Jon's Life").and_return(fake_movie)
      post :create, :movie => {:id => 99, :title => "A Jon's Life"}
      flash[:notice].should eq("A Jon's Life was successfully created.")
    end
  end
  
  describe 'Edit a Movie' do
    let (:fake_movie) {double("movie", :id => 1)}
    it 'should go to the edit page' do
      Movie.should_receive(:find).with("1").and_return(fake_movie)
      get :edit, :id => 1
      response.should render_template('edit')
    end
  end

  
  describe 'Update a Movie' do
    let (:fake_movie) {double("movie", :id => 3, :title => "Alien", :director => "")}
    it 'should find a movie and update the director when asked' do
      Movie.should_receive(:find).with("3").and_return(fake_movie)
      fake_movie.should_receive(:update_attributes!).with("id" => "3", "title"=> "Alien", "director" => "Ridley Scott")
      fake_movie.should_receive(:title)
      put :update, :id => 3, :movie => {:id => 3, :title => "Alien", :director => "Ridley Scott"}
    end
    it 'should display a nice message' do
      Movie.should_receive(:find).with("3").and_return(fake_movie)
      fake_movie.should_receive(:update_attributes!).with("id" => "3", "title" => "Alien")
      fake_movie.should_receive(:title)
      put :update, :id => 3, :movie => {:id => 3, :title => "Alien"}
      flash[:notice].should eq("Alien was successfully updated.")
    end
  end
  
  describe 'Delete a Movie' do
    let (:fake_movie) {double("movie", :id => 1, :title => "Star Wars")}
    it 'should find and delete the movie' do
      Movie.should_receive(:find).with("1").and_return(fake_movie)
      fake_movie.should_receive(:destroy)
      delete :destroy, :id => 1
    end
    it 'should display a nice message' do
      Movie.should_receive(:find).with("1").and_return(fake_movie)
      fake_movie.should_receive(:destroy)
      delete :destroy, :id => 1
      flash[:notice].should eq("Movie 'Star Wars' deleted.")
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
        assigns(:movie).should == fake_movie
      end
      it 'should select the Similar template for rendering' do
        fake_movie.stub(:other_movies_by_director)
        get :similar, :id => 1
        response.should render_template('similar')
      end
      it 'should make the model other movies search method results available to that template' do
        Movie.should_receive(:find).with("1").and_return(fake_movie)
        fake_movie.stub(:other_movies_by_director).and_return(fake_results)
        get :similar, :id => 1
        assigns(:movies).should == fake_results
      end
    end
    context 'given a movie a black or nil known director' do
      let (:fake_movie) {double("movie", :title => "A Movie", :director => nil)}
      let (:fake_movie_2) {double("movie", :title => "A Movie", :director => "")}
      it 'should call the model method that searches for movies by same director with nil director and not fail' do
        Movie.should_receive(:find).with("1").and_return(fake_movie)
        get :similar, :id => 1
        assigns(:movie).should == fake_movie
      end
      it 'should call the model method that searches for movies by same director with blank director and not fail' do
        Movie.should_receive(:find).with("1").and_return(fake_movie_2)
        get :similar, :id => 1
        assigns(:movie).should == fake_movie_2       
      end
      it 'should not select the Similar template for rendering' do
        Movie.should_receive(:find).with("1").and_return(fake_movie_2)
        get :similar, :id => 1
        response.should_not render_template('similar')
      end
      it 'should set the flash message' do
        Movie.should_receive(:find).with("1").and_return(fake_movie_2)
        get :similar, :id => 1
        flash[:notice].should eq("'#{fake_movie.title}' has no director info")
      end
    end
  end
end
