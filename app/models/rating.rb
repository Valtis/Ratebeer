class Rating < ActiveRecord::Base
  belongs_to :beer
  belongs_to :user

  def to_s
    "Beer: #{beer.name} Rating: #{score}"
  end
end
