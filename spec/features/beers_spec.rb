require 'rails_helper'

describe "Beers page" do

  before :each do
    FactoryGirl.create :user
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "allow user to create new beer" do
    visit new_beer_path
    fill_in('beer_name', with:'test_name')

    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)
  end
  it "redirects user back to creation page with error message if name field is empty" do

    visit new_beer_path

    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(0)


    expect(current_path).to eq(beers_path)
    expect(page).to have_content "Name can't be blank"

  end




end