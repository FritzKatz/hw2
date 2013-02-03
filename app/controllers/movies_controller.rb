class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.rating_list    
    @movies = Movie.all
    @checked_rating = params[:ratings]

    if params[:sorted] == 'title' and params[:ratings] == nil
      @movies = Movie.all(:order => 'title')
      @title_hilite = 'hilite'
    end
    if params[:sorted] == 'release_date' and params[:ratings] == nil
      @movies = Movie.all(:order => 'release_date ASC')
      @release_date_hilite = 'hilite'
    end

    if params[:submit] != nil or params[:ratings] != nil         
      #@checked_rating = params[:ratings]            
      @movies = Movie.where(:rating => @checked_rating.keys)           
    end

    if params[:sorted] == 'title' and params[:ratings] != nil
      #@checked_rating = params[:ratings]      
      @movies = Movie.where(:rating => @checked_rating.keys).order('title ASC')      
      @title_hilite = 'hilite'      
    end
    if params[:sorted] == 'release_date' and params[:ratings] != nil
      #@checked_rating = params[:ratings]      
      @movies = Movie.where(:rating => @checked_rating.keys).order('release_date ASC')
      @release_date_hilite = 'hilite'
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
