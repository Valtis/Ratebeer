class RatingsController < ApplicationController

  before_action :ensure_that_signed_in, except: [:index, :show]

  # cachettaa tulokset 10 minuutiksi
  # periaatteessa olisi kiva, että cachen päivitys tapahtuisi taustalla, koska päivitysoperaatio on hidas
  def index
    calculate_if_not_cached

    @beers = Rails.cache.read "beer_top_3"
    @breweries = Rails.cache.read "breweries_top_3"
    @styles = Rails.cache.read "styles_top_3"
    @users = Rails.cache.read "users_top_3"
    @recent_ratings = Rails.cache.read "recent_ratings_top_3"

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
private

  def calculate_if_not_cached
    Rails.cache.fetch("beer_top_3", :expires_in => 10.minutes) { Beer.top_average_ratings 3 }
    Rails.cache.fetch("breweries_top_3", :expires_in => 10.minutes) { Brewery.top_average_ratings 3 }
    Rails.cache.fetch("styles_top_3", :expires_in => 10.minutes) { Style.top_average_ratings 3 }
    Rails.cache.fetch("users_top_3", :expires_in => 10.minutes) { User.top_ratings_count 3 }
    Rails.cache.fetch("recent_ratings_top_3", :expires_in => 10.minutes) { Rating.recent }
  end
end

