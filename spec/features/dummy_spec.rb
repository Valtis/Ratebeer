require 'rails_helper'

describe "dummy" do

  it "makes sure all modules are listed in coverage report" do
    BeerClubsController
    Membership
    BeerClub
  end
end
