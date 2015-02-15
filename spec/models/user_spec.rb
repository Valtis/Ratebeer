require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has the username set correctly' do
    user = User.new username: 'Pekka'
    expect(user.username).to eq('Pekka')
  end

  it 'should not be saved without password' do
    user = User.create username: 'Pekka'
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it 'should not be saved if password is too short' do
    user = User.create username: 'Pekka', password: 'F1', password_confirmation: 'F1'
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it 'should not be saved if password contains only letters' do
    user = User.create username: 'Pekka', password: 'aaaaaaaaa', password_confirmation: 'aaaaaaaaa'
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it 'should not be saved if password and verification do not match' do
    user = User.create username: 'Pekka', password: 'Foobar1', password_confirmation: 'Foobar2'
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end


  describe 'favorite beer' do
    let!(:user) { user = FactoryGirl.create(:user) }

    it 'has method to determine one' do
      expect(user).to respond_to(:favorite_beer)
    end

    it 'without ratings does not have one' do
      expect(user.favorite_beer).to eq(nil)
    end

    it 'is the only rated if only one rating' do
      beer = create_beer_with_rating(10, user)
      expect(user.favorite_beer).to eq(beer)
    end

    it 'is the one with highest rating if several rated' do
      create_beers_with_ratings(10, 20, 9, 15, 23, user)
      best = create_beer_with_rating(25, user)
      create_beers_with_ratings(7, 14, 21, user)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe 'favorite_style' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:style1) { FactoryGirl.create(:style) }
    let!(:style2) { FactoryGirl.create(:style, name: "aaa") }
    let!(:style3) { FactoryGirl.create(:style, name: "bbb") }



    it 'without ratings does not have one' do
      expect(user.favorite_style).to eq(nil)
    end

    it 'with single beer is the only style' do
      create_beers_with_scores_and_style(15, style1, user)
      expect(user.favorite_style).to eq(style1)
    end

    it 'with multiple beers is the only with highest average score' do


      create_beers_with_scores_and_style(15, 10, 20, 4, style1, user)
      create_beers_with_scores_and_style(30, 40, 20, style2, user)
      create_beers_with_scores_and_style(10, 9, 50, 2, 32, style3, user)

      expect(user.favorite_style).to eq(style2)
    end
  end

  describe 'favorite_brewery' do
    let!(:user) { FactoryGirl.create(:user) }

    it 'without ratings does not have one' do
      expect(user.favorite_brewery).to eq(nil)
    end

    it 'with single brewery is the only brewery' do
      brewery = create_ratings_for_brewery(10, 20, 30, 40, user)
      expect(user.favorite_brewery).to eq(brewery)
    end

    it 'with multiple breweries is the brewery with highest average score' do
      create_ratings_for_brewery(10, 20, 30, 40, user)
      create_ratings_for_brewery(10, 15, 12, 40, user)
      brewery = create_ratings_for_brewery(30, 25, 35, 32, user)
      create_ratings_for_brewery(10, 50, 10, 2, user)

      expect(user.favorite_brewery).to eq(brewery)
    end
  end


  describe 'with a proper password' do
    let!(:user) { FactoryGirl.create(:user) }

    it 'is saved with proper password' do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it 'and with two ratings, has correct average rating' do

      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.average_rating).to eq(15)
    end

  end


  def create_beer_with_rating(score, user)
    beer = FactoryGirl.create(:beer)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end

  def create_beers_with_ratings(*scores, user)
    scores.each do |score|
      create_beer_with_rating(score, user)
    end
  end

  def create_beers_with_scores_and_style(*scores, style, user)
    scores.each do |score|

      beer = FactoryGirl.create(:beer, style: style)
      FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    end
  end

  def create_ratings_for_brewery(*scores, user)
    brewery = FactoryGirl.create(:brewery)
    scores.each do |score|
      beer = FactoryGirl.create(:beer, brewery: brewery)
      FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    end
    brewery
  end

end
