module AverageRating
  extend ActiveSupport::Concern
  def average_rating
    self.ratings.average(:score)
  end
end