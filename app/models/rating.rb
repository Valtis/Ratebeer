class Rating < ActiveRecord::Base
  belongs_to :beer, touch: true
  belongs_to :user

  validates :score, numericality: { greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 50,
                                    only_integer: true }

  def to_s
    "Beer: #{beer.name} Rating: #{score}"
  end

  scope :recent, -> { order('id DESC').limit(5) }


end
