class RatingsController < ApplicationController

  before_action :ensure_that_signed_in, except: [:index, :show]
  def index
    @beers = Beer.top_average_ratings 3
    @breweries = Brewery.top_average_ratings 3
    @styles = Style.top_average_ratings 3
    @users = User.top_ratings_count 3
    @recent_ratings = Rating.recent
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if @rating.save
      current_user.ratings << @rating
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def show
    rating = Rating.find(params[:id])
    redirect_to user_path(rating.user)
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user ==  rating.user
    redirect_to :back
  end

end

