class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings

  def average_rating
    ratings.inject(0) { |total, rating| total + rating.score } / ratings.count
  end
end
