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

  describe 'with a proper password' do
    let!(:user) { User.create username: 'Pekka', password: 'Foobar1', password_confirmation: 'Foobar1' }

    it 'is saved with proper password' do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it 'and with two ratings, has correct average rating' do
      rating = Rating.new score: 10
      rating2 = Rating.new score: 20

      user.ratings << rating
      user.ratings << rating2

      expect(user.average_rating).to eq(15)
    end

  end
end
