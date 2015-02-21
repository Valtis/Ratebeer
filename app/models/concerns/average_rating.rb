module AverageRating
  extend ActiveSupport::Concern

  def self.included(base)
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods
  end

  module InstanceMethods
    def average_rating
      return 0 if self.ratings.empty?
      self.ratings.average(:score)
    end
  end

  module ClassMethods
    def top_average_ratings(n)
      sorted_by_rating_in_desc_order = self.all.sort_by{ |b| -(b.average_rating||0) }
      sorted_by_rating_in_desc_order.take n
    end

    def top_ratings_count(n)
      sorted_by_count = self.all.sort_by{ |b| -b.ratings.count }
      sorted_by_count .take n
    end
  end
end