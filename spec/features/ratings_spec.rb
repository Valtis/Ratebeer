require 'rails_helper'


include OwnTestHelper


describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  # one test to rule them all
  it "shows list of beers, breweries, styles, raters and ratings" do
    r1 = Rating.create beer: beer1, user: user, score: 10
    r2 = Rating.create beer: beer2, user: user, score: 20


    visit ratings_path


    expect(page).to have_content "#{r1.beer.name}"
    expect(page).to have_content "#{r2.beer.name}"


    expect(page).to have_content "#{r1.beer.brewery.name}"
    expect(page).to have_content "#{r2.beer.brewery.name}"

    expect(page).to have_content "#{r1.beer.style}"
    expect(page).to have_content "#{r2.beer.style}"

    expect(page).to have_content "#{user.username}"

    expect(page).to have_content "#{r1.score}"
    expect(page).to have_content "#{r2.score}"
  end

end