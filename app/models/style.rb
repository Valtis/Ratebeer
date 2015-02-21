class Style < ActiveRecord::Base
  include AverageRating
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def to_s
    name
  end
end
