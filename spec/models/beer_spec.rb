require 'rails_helper'

# oluen luonti onnistuu ja olut tallettuu kantaan jos oluella on nimi ja tyyli asetettuna
# oluen luonti ei onnistu (eli creatella ei synny validia oliota), jos sille ei anneta nimeä
# oluen luonti ei onnistu, jos sille ei määritellä tyyliä


RSpec.describe Beer, type: :model do
  it 'should be saved if name and style has been set correctly' do
    beer = Beer.create name: 'Beeeeeeeer', style: 'stylish'
    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it 'should not be saved if name is missing' do
    beer = Beer.create style: 'stylish'
    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it 'should not be saved if style is missing' do
    beer = Beer.create name: 'Beeeeeeeer'
    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
