class Beer < ActiveRecord::Base
  include AverageRating
  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user


  validates :name, presence: true
  validates :style, presence: true

  def to_s
    "#{brewery.name}: #{name}"
  end
end
