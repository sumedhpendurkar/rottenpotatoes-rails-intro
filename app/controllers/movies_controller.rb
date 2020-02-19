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
    @all_ratings = Movie.get_all_ratings
    redirect = false 
    if (params).key?(:sort_field)
        @sort_var = params[:sort_field]
        session[:sort_field] = @sort_var
    elsif session[:sort_field]
        @sort_var = session[:sort_field]
        #need redirect
        rediret = true
    end
    @set_ratings = nil
    if params[:commit] =='Refresh' and params[:ratings].nil?
      @set_ratings = session[:ratings]
      session[:ratings] = nil
    elsif params.key?(:ratings)
      @set_ratings = params[:ratings]
      session[:ratings] = @set_ratings
    elsif session.key?(:ratings)
      @set_ratings = session[:ratings]
      redirect = true
    end
    if redirect
      flash.keep
      redirect_to(:action=>'index',:sort_field=>@sort_var,:ratings=>@set_ratings)
    end
    if @set_ratings and @sort_var
      @movies = Movie.where(:rating=>@set_ratings.keys).order(@sort_var)
    elsif @set_ratings
      @movies = Movie.where(:rating=>params[:ratings].keys)
    elsif @sort_var
      @movies = Movie.all.order(params[:sort_field])
      @set_ratings = Hash.new(@all_ratings)
    else
      @movies = Movie.all
      @set_ratings = Hash.new(@all_ratings)
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
