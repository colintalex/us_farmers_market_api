require 'rails_helper'
require './db/csv/model_manager.rb'

describe "Market Queries" do
  before :each do
    ActiveRecord::Base.connection.tables.each do |t|
      ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end
    ModelManager.destroy_and_create_markets(File.open('./spec/fixtures/markets.csv'))
  end
  it "can return all markets" do
    expect(Market.count).to eq(50)
    post('/', params: { query: 'query { allMarkets { id marketname products { id name } }}'})
    markets = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)
    expect(markets[:data][:allMarkets].size).to eq(50)
    market = markets[:data][:allMarkets][0]
    expect(market).to have_key(:id)
    expect(market).to have_key(:marketname)
    expect(market).to have_key(:products)
    expect(market[:products].count).to eql(21)
  end

  it "can return a single market" do
    expect(Market.count).to eq(50)
    post('/', params: { query: 'query { market(id: 1) { id marketname products { id name } }}'})
    market = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)
    market = market[:data][:market]
    expect(market).to have_key(:id)
    expect(market).to have_key(:marketname)
    expect(market).to have_key(:products)
    expect(market[:products].count).to eql(21)
  end

  it 'can return markets near a given lat,lng' do
    post('/', params: { query: 'query { marketsByCoords(lat: 44.411037, lng: -72.140335, radius: 280) { markets { marketname fmid distance } } }'})
    markets = JSON.parse(response.body, symbolize_names: true)

    expect(markets[:data][:marketsByCoords][:markets].size).to eq(10)
    expect(markets[:data][:marketsByCoords][:markets][0][:fmid]).to eq(1018261)
  end

  it 'can return markets distance away from a given lat, lng' do
    post('/', params: { query: 'query { marketsByCoords(lat: 44.411037, lng: -72.140335, radius: 280) { markets { marketname fmid  distance } } }'})
    markets = JSON.parse(response.body, symbolize_names: true)

    expect(markets[:data][:marketsByCoords][:markets][0][:distance]).to eq(0.0)
    expect(markets[:data][:marketsByCoords][:markets].last[:distance].round(2)).to eq(268.62)
  end
  it 'can return city and state for given lat and lng' do
    post('/', params: { query: 'query { marketsByCoords(lat: 44.411037, lng: -72.140335, radius: 280) { markets { marketname fmid distance } location } }'})
    markets = JSON.parse(response.body, symbolize_names: true)

    expect(markets[:data][:marketsByCoords][:location]).to eq('Danville, Vermont')
  end
  it 'can filter marketsByCoords by products' do
    post('/', params: { query: 'query { marketsByCoords(lat: 44.411037, lng: -72.140335, radius: 280, products: ["bakedgoods", "fruits", "cheese", "flowers", "eggs", "seafood"]) { markets { marketname fmid distance products { name } } } }'})
    markets = JSON.parse(response.body, symbolize_names: true)

    expect(markets[:data][:marketsByCoords][:markets].size).to eq(2)
    expect(markets[:data][:marketsByCoords][:markets].first[:fmid]).to eq(1016782)
    expect(markets[:data][:marketsByCoords][:markets].last[:fmid]).to eq(1000061)
    expect(markets[:data][:marketsByCoords][:markets].sample[:products].map(&:values).flatten).to include("bakedgoods", "fruits", "cheese", "flowers", "eggs", "seafood")
  end
  it 'can return markets near a given city, state' do
    post('/', params: { query: 'query { marketsByCity(city: "Dayton", state: "Ohio", radius: 200) { markets { marketname distance } latitude longitude } }'})
    markets = JSON.parse(response.body, symbolize_names: true)

    expect(markets[:data][:marketsByCity][:markets].size).to eq(4)
    expect(markets[:data][:marketsByCity][:markets].first[:marketname]).to eq("2nd Street Market - Five Rivers MetroPark")
    expect(markets[:data][:marketsByCity][:latitude]).to eq(39.7589478)
    expect(markets[:data][:marketsByCity][:longitude]).to eq(-84.1916069)
  end
  it 'can filterMarketsByCity by products' do
    post('/', params: { query: 'query { marketsByCity(city: "Dayton", state: "Ohio", radius: 200, products: ["bakedgoods", "fruits"]) { markets { marketname products { name } } } }'})
    markets = JSON.parse(response.body, symbolize_names: true)

    expect(markets[:data][:marketsByCity][:markets].size).to eq(3)
    expect(markets[:data][:marketsByCity][:markets].first[:marketname]).to eq("2nd Street Market - Five Rivers MetroPark")
    expect(markets[:data][:marketsByCity][:markets].sample[:products].map(&:values).flatten).to include("bakedgoods", "fruits")
  end
end
