class User < ActiveRecord::Base
  include AverageRating
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  has_secure_password

  validates :username, uniqueness: true,  length: { minimum: 3, maximum: 15 }
  validates :password, length: { minimum: 4 }
  validate :password_contains_capital_letter_and_number

  def password_contains_capital_letter_and_number
    if  not password =~ /[A-Z]/ and not password =~ /[0-9]/
      errors.add(:password, "must contain at least one capital letter and a number #{password}")
    end
  end

  def favorite_beer
    return nil if ratings.empty?   # palautetaan nil jos reittauksia ei ole
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    style_ratings = ratings.group_by{|r| r.beer.style }.map { |key, value| create_key_average_score_array(key, value) }
    get_key_with_highest_value(style_ratings)
  end

  def favorite_brewery
    return nil if ratings.empty?

    brewery_ratings = ratings.group_by{|r| r.beer.brewery }.map { |key, value| create_key_average_score_array(key, value) }

    get_key_with_highest_value(brewery_ratings)
  end





  private

  def create_key_average_score_array(key, value)
    [ key, get_sum_of_scores(value)/value.count ]
  end

  def get_key_with_highest_value(key_value_array)
    key_value_array.sort_by { |k| k[1]}.last[0]
  end

  def get_sum_of_scores(rating_array)
    rating_array.inject(0){|sum, r| sum + r.score }.to_f
  end


end
