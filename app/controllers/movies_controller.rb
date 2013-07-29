class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.rating_list        
    @checked_rating = params[:ratings] || session[:ratings] || {}
    sorted = params[:sorted] || session[:sorted]
    #@movies = Movie.all
   

   
    # #If the session contains ratings these will be used
    # if session[:ratings] == nil && session[:sorted] == nil
    #   @movies = Movie.all
    #   #params[:ratings] = session[:ratings]      
    # elsif session[:ratings] != nil || session[:sorted] != nil      
    #   params[:sorted] = session[:sorted]
    #   params[:ratings] = session[:ratings]
    #   redirect_to :action => :index
    #   #redirect_to :sorted => params[:sorted], :ratings => params[:ratings] #and return
    #   #@movies = Movie.where(:rating => session[:ratings].keys).order(sorted)            
    # end

    # If all checkboxes are unchecked the settings stored in the session hash will be used

    if @checked_rating == {}           
      @all_ratings.each do |rating|
        @checked_rating[rating] = rating
      end
    end

    # If the values of the params and session hash differ   

    if params[:ratings] != session[:ratings] || params[:sorted] != session[:sorted]
      session[:sorted] = sorted
      session[:ratings] = @checked_rating
      flash.keep
      redirect_to :sorted => sorted, :ratings => @checked_rating and return
    end      
    
    # The list is either being sorted by title or by release_date with all ratings
    
    if params[:sorted] == 'title'
      @title_hilite = 'hilite'
      session[:sorted] = params[:sorted]
      session[:ratings] = params[:ratings]
      if params[:ratings] == nil
        @movies = Movie.where(:rating => session[:ratings].keys).order('title ASC')        
        #@movies = Movie.all(:order => 'title')
      elsif params[:ratings] != nil        
        @movies = Movie.where(:rating => @checked_rating.keys).order('title ASC')
      end
    elsif params[:sorted] == 'release_date'
      @release_date_hilite = 'hilite'
      session[:sorted] = params[:sorted]
      session[:ratings] = params[:ratings] 
      if params[:ratings] == nil
        @movies = Movie.where(:rating => session[:ratings].keys).order('release_date ASC')        
        #@movies = Movie.all(:order => 'release_date ASC')
      elsif params[:ratings] != nil        
        @movies = Movie.where(:rating => @checked_rating.keys).order('release_date ASC')
      end
    elsif params[:sorted] == nil
      session[:sorted] = params[:sorted]
      session[:ratings] = params[:ratings] 
      #if params[:ratings] == nil
        #@movies = Movie.where(:rating => @checked_rating.keys)
      #elsif params[:ratings] != nil        
        @movies = Movie.where(:rating => @checked_rating.keys)
      #end
    end

    # if params[:commit] != nil && params[:ratings] != nil      
    #   session.clear
    #   session[:ratings] = params[:ratings]
    #   @movies = Movie.where(:rating => @checked_rating.keys)
    # elsif params[:commit] != nil && params[:ratings] == nil 
    #   session.clear
    #   session[:ratings] = params[:ratings]
    #   @movies = Movie.where(:rating => [])      
    # end
    

     
    ###########################

    # The list is being sorted by title with all ratings

    # if params[:sorted] == 'title' and params[:ratings] == nil
    #   session[:sorted] = params[:sorted]
    #   @movies = Movie.all(:order => 'title')
    #   @title_hilite = 'hilite'
    # end

    # The complete list is being sorted by release date with all ratings

    # if params[:sorted] == 'release_date' and params[:ratings] == nil
    #   session[:sorted] = params[:sorted]
    #   @movies = Movie.all(:order => 'release_date ASC')
    #   @release_date_hilite = 'hilite'
    # end

    # The refresh buttion is used and the list is filtered by the selected ratings; the session is reset

    # if params[:submit] != nil #or params[:ratings] != nil
    #   session.clear
    #   session[:ratings] = params[:ratings]        
    #   #@checked_rating = params[:ratings]            
    #   @movies = Movie.where(:rating => @checked_rating.keys)           
    # end

    # The selected list is being sorted by title

    # if params[:sorted] == 'title' and params[:ratings] != nil
    #   #@checked_rating = params[:ratings]
    #   session[:sorted] = params[:sorted]      
    #   @movies = Movie.where(:rating => @checked_rating.keys).order('title ASC')      
    #   @title_hilite = 'hilite'      
    # end

    # The selected list is being sorted by release date

    # if params[:sorted] == 'release_date' and params[:ratings] != nil
    #   #@checked_rating = params[:ratings]
    #   session[:sorted] = params[:sorted]      
    #   @movies = Movie.where(:rating => @checked_rating.keys).order('release_date ASC')
    #   @release_date_hilite = 'hilite'
    # end

    ######
    # if params[:sorted] != session[:sorted] or params[:ratings] != session[:ratings]

    #   session[:sorted] = sorted
    #   session[:ratings] = @checked_rating
    #   @movies = Movie.where(:rating => @checked_rating.keys).order('title ASC') 
    #   redirect_to :sorted => sorted, :ratings => @checked_rating and return
    # end
    # @movies = Movie.find_all_by_rating(@selected_ratings.keys, ordering)
#####

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
