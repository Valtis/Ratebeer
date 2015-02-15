require 'rails_helper'
include OwnTestHelper

describe "User" do
  before :each do
    @user = FactoryGirl.create :user
    @user2 = FactoryGirl.create(:user, username: "Marko")

    @user3 = FactoryGirl.create(:user, username: "Petteri")
    brewery = FactoryGirl.create :brewery
    @beer = FactoryGirl.create :beer, name:"iso 3", brewery:brewery
    @beer2 = FactoryGirl.create :beer, name:"testi", brewery:brewery

    @r1 = Rating.create beer: @beer, user: @user, score: 20
    @r2 = Rating.create beer: @beer2, user: @user, score: 30
    @r3 = Rating.create beer: @beer, user: @user2, score: 10

  end

  describe "who has signed up" do


    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Invalid username or password'
    end

    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', with:'Brian')
      fill_in('user_password', with:'Secret55')
      fill_in('user_password_confirmation', with:'Secret55')

      expect{
        click_button('Create User')
      }.to change{User.count}.by(1)
    end

    it "and has reviews lists users favorite brewery and style" do
      visit user_path(@user)
      expect(page).to have_content 'Favorite brewery: anonymous'
      expect(page).to have_content 'Favorite style: lager'
    end

    it "and has no reviews lists notification about no style and brewery" do
      visit user_path(@user3)
      expect(page).to have_content 'Favorite brewery: No favorite brewery yet '
      expect(page).to have_content 'Favorite style: No favorite style yet '
    end

  end

  describe "who has signed in" do
    before :each do
      sign_in(username:"Pekka", password:"Foobar1")
    end

    it "can delete a rating they have made" do
      visit user_path(@user)
      page.find('li', :text => @r2.to_s).click_link 'delete'
      expect(@user.ratings.count).to eq(1)
      expect(@user.ratings.first).to eq(@r1)

    end
  end
end