class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if params[:ratings] == nil && session[:ratings] != nil
      @filters = @all_ratings
      params[:ratings] = session[:ratings]
    end
    @filters = params[:ratings].nil? ? @all_ratings : params[:ratings]
    
    
    
    if(params[:ratings])
      session[:ratings] = params[:ratings]
      @filters = params[:ratings]
    elsif (session[:ratings])
      if params[:sort] == nil
        redirect_to movies_path({:ratings => params[:ratings]})
      else
        redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
      end
    end
    
    if(params[:sort] && params[:ratings] != nil)
      @renderMovies = params[:sort] == "title" ? true : false
      @renderRelease = params[:sort] == "release_date"? true : false
      session[:sort] = params[:sort]
      @movies = Movie.where(:ratings => @filters)
      @movies = @movies.order(params[:sort])
    elsif(params[:sort] && params[:ratings] == nil)
      @renderMovies = params[:sort] == "title" ? true : false
      @renderRelease = params[:sort] == "release_date"? true : false
      session[:sort] = params[:sort]
      @movies = Movie.order(params[:sort])
    elsif(session[:sort])
      redirect_to movies_path({:sort => session[:sort], :ratings => session[:ratings]})
    else
      @movies = Movie.all
    end
  def new  
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

