module Types
  class QueryType < Types::BaseObject
    description "Queries to retrieve farmers market data."

    field :all_markets, [Types::MarketType], "Retrieve all markets.", null: false
    def all_markets
      Market.all
    end

    field :market, Types::MarketType, "Retrieve single market info based on id.", null: false do
      argument :id, Integer, required: true
    end
    def market(id:)
      Market.find(id)
    end

    field :markets_by_coords, Types::ReturnType, "Retrieve markets within a radius of latitude, longitude.", null: false do
      argument :lat, Float, required: true
      argument :lng, Float, required: true
      argument :radius, Integer, "Units: Miles", required: true
      argument :products, [GraphQL::Types::String], "Format: ['bakedgoods','cheese']", required: false
      argument :date, String, "Format: DD/MM/YYYY", required: false
    end
    def markets_by_coords(lat:, lng:, radius:, products: '', date: '')
      markets = Market.near([lat, lng], radius)
      if !products.empty?
        markets = markets.joins(:products)
                         .where(products: { name: products })
                         .group('markets.id')
                         .having('count(distinct products.id) = ?', products.size)
      end
      markets = markets.order_by_closest_date(date) if !date.empty?
      location_object = Geocoder.search([lat, lng]).first
      location = "#{location_object.city}, #{location_object.state}"
      { markets: markets,
        location: location
      }
    end

    field :markets_by_city, Types::ReturnType, "Retrieve markets within a radius of city, state.", null: false do
      argument :city, String, required: true
      argument :state, String, required: true
      argument :radius, Integer, "Units: Miles", required: true
      argument :products, [GraphQL::Types::String], "Format: ['bakedgoods','cheese']", required: false
      argument :date, String, "Format: DD/MM/YYYY", required: false
    end
    def markets_by_city(city:, state:, radius:, products: '', date: '')
      markets = Market.near("#{city}, #{state}", radius)
      if !products.empty?
        markets = markets.joins(:products)
                         .where(products: { name: products })
                         .group('markets.id')
                         .having('count(distinct products.id) = ?', products.size)
      end
      markets = markets.order_by_closest_date(date) if !date.empty?
      coords = Geocoder.search("#{city}, #{state}").first.coordinates
      { markets: markets,
        latitude: coords.first,
        longitude: coords.last
      }
    end

    field :markets_by_date, [Types::MarketType], "Retrieve markets nearest a given date.", null: false do
      argument :date, String, "Format: DD/MM/YYYY", required: true
    end
    def markets_by_date(date:)
      Market.order_by_closest_date(date)
    end

    field :markets, [Types::MarketType], "Retrieves markets based on fmid.", null: false do
      argument :fmids, [Integer], "Format: [1018261, 1018318]", required: true
    end
    def markets(fmids:)
      Market.where(fmid: fmids)
    end
  end
end
