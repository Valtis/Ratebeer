json.array!(@active_breweries + @retired_breweries) do |brewery|
  json.extract! brewery, :id, :name, :year, :beers
end
