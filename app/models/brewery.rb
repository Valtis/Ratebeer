class Brewery < ActiveRecord::Base
  include AverageRating
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers
  validates :name, presence: true

  validates :year, numericality: { greater_than_or_equal_to: 1042, only_integer: true }
  validate :year_cannot_be_in_the_future

  def year_cannot_be_in_the_future
    if Date.today.year < year
      errors.add(:year, " cannot be in the future (for time travellers, current year is #{Date.today.year}")
    end
  end



end
