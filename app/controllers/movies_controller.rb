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
    @movies = Movie.order(params[:sort])
    if params.key?(:sort)
      session[:sort] = params[:sort]
    elsif session.key?(:sort)
      params[:sort] = session[:sort]
      redirect_to movies_path(params) and return
    end
    @all_ratings = Movie.all_ratings
    if params.key?(:sort)
      session[:sort] = params[:sort]
    elsif session.key?(:sort)
      params[:sort] = session[:sort] and return
    end
    ratings = params[:ratings] != nil ? params[:ratings].keys : @all_ratings
    @rating_checked = Hash[@all_ratings.map{|r|[r,ratings.include?(r)]}]
    @movies = Movie.where(rating: ratings)
    @renderMovies = params[:sort] == "title" ? true : false
    @renderRelease = params[:sort] == "release_date"? true : false
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

end
