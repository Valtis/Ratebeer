require 'rails_helper'
include OwnTestHelper

describe "User" do
  before :each do
    @user = FactoryGirl.create :user
    @user2 = FactoryGirl.create(:user, username: "Marko")
    brewery = FactoryGirl.create :brewery
    @beer = FactoryGirl.create :beer, name:"iso 3", brewery:brewery
    @beer2 = FactoryGirl.create :beer, name:"testi", brewery:brewery

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

    it "has ratings listed in their userpage" do

      r1 = Rating.create beer: @beer, user: @user, score: 20
      r2 = Rating.create beer: @beer2, user: @user, score: 30
      r3 = Rating.create beer: @beer, user: @user2, score: 10

      visit user_path(@user)


      expect(page).to have_content "#{@user.username} has made 2 ratings"
      expect(page).to have_content "#{r1}"
      expect(page).to have_content "#{r2}"
      expect(page).not_to have_content "#{r3}"

    end

  end
end