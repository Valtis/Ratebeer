class Rating < ActiveRecord::Base
  belongs_to :beer


  def to_s
    "Beer: #{beer.name} Rating: #{score}"
  end
end
