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
    all_ratings = Movie.group(:rating)
    @all_ratings = Array.new
    all_ratings.each do |rat|
    	@all_ratings.append(rat.rating)
    end
    @sort_var = params[:sort_field]
    if (params).key?(:ratings)
	@set_ratings = params[:ratings]
    	@movies = Movie.order(@sort_var).where(rating: params[:ratings].keys)
    else
	@set_ratings = Hash.new(@all_ratings)
	@movies = Movie.order(@sort_var)
    end
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
