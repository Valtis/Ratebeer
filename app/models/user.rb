class User < ActiveRecord::Base
  include AverageRating
  has_many :ratings
  has_many :beers, through: :ratings
  has_many :memberships
  has_many :beer_clubs, through: :memberships

  has_secure_password

  validates :username, uniqueness: true,  length: { minimum: 3, maximum: 15 }
  validates :password, length: { minimum: 4 }
  validate :password_contains_capital_letter_and_number

  def password_contains_capital_letter_and_number
    if  not password =~ /[A - Z]/ and not password =~ /[0 - 9]/
      errors.add(:password, "must contain at least one capital letter and a number")
    end
  end
end
