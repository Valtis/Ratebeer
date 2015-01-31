module AverageRating
  extend ActiveSupport::Concern
  def average_rating
    return 0 if self.ratings.empty?
    self.ratings.average(:score)
  end
end