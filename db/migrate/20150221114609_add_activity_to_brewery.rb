class AddActivityToBrewery < ActiveRecord::Migration
  def change
    add_column :breweries, :active, :boolean

    Brewery.all.each do |brewery|
      brewery.active = true
      brewery.save
    end
  end
end
