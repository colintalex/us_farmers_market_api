[![Build Status](https://travis-ci.com/tylerpporter/us_farmers_market_api.svg?branch=master)](https://travis-ci.com/tylerpporter/us_farmers_market_api) [![Coverage Status](https://img.shields.io/coveralls/aterris/simplecov-shield.svg)](https://coveralls.io/r/aterris/simplecov-shield?branch=master)

# US Farmers Markets API

*This [GraphQL](https://graphql.org/) API was created to replace the current [USDA National Farmers Market Directory API](https://search.ams.usda.gov/farmersmarkets/v1/svcdesc.html).*

**Provides quick and easy search results across all USDA registered farmers markets, sourcing 2020 CSV data.**  
**With a single query to this API, farmers markets can be retrieved and filtered by location, products offered, and date.**


## Table of Contents:
- [Running Locally](#running-locally)
- [Queries](#queries)
  - [allMarkets](#allmarkets)
  - [market](#market)
  - [marketsByCoords](#marketsbycoords)
  - [marketsByCity](#marketsbycity)
  - [marketsByDate](#marketsbydate)
- [Tech Stack](#tech-stack)
- [Contributors](#contributors)
***
## Running Locally
[top](#us-farmers-markets-api)
- Setup - Run all commands in Terminal from the project root folder
  - Fork and clone this repo
  - Run `bundle install`
  - Run `rails db:create`
  - Run `rails db:migrate`
  - Run `rake db:seed:from_csv` (will take several minutes)
- Running Tests
  - run `bundle exec rspec`
- Server
  - To fire up the server, run `rails s`
  - In your Chrome browser, visit `localhost:3000/graphiql`
- GraphiQL
  - In the upper right-hand corner, click `Docs`
  - Click `Query` to see all available queries

***
## Queries
[top](#us-farmers-markets-api)

The root path for all queries is `https://us-farmers-markets-api.herokuapp.com/` using the `POST` verb. If running locally, use `localhost:3000/graphiql`.
***
### allMarkets
[queries](#queries)

Retrieves all USDA registered farmers markets.

Optional market return attributes (must include at least 1):
- `id`
- `latitude`
- `longitude`
- `marketname`
- `products`
  - `name`
- `seasonDates`
- `city`
- `state`
- `zip`
- `website`

Request:
```
query {
  allMarkets {
    marketname
  }
}
```
Response:
```
{
  "data": {
    "allMarkets": [
      {
        "marketname": " Caledonia Farmers Market Association - Danville"
      },
      {
        "marketname": " Stearns Homestead Farmers' Market"
      },
      {
        "marketname": "106 S. Main Street Farmers Market"
      }
    ]
  }
}
```
### market
[queries](#queries)

Retrieves a single market based on `id`.

Optional market return attributes (must include at least 1):
- `id`
- `latitude`
- `longitude`
- `marketname`
- `products`
  - `name`
- `seasonDates`
- `city`
- `state`
- `zip`
- `website`

Request:
```
query {
  market(id: 1) {
    marketname
  }
}
```
Response:
```
{
  "data": {
    "market": {
      "marketname": " Caledonia Farmers Market Association - Danville"
    }
  }
}
```
### marketsByCoords
[queries](#queries)

Retrieves markets within `x` radius of `lat`, `lng`. Optional arguments include `products` and `date`.
- `products` takes an array of strings where each string is a product offering to filter the returning markets by
- `date` takes a single date and returns markets sorted by the nearest matching date

Optional return attributes (must include at least 1):
- `markets`
  - `closestDate` (if given optional `date` arg)
  - `distance`
  - `id`
  - `latitude`
  - `longitude`
  - `marketname`
  - `products`
    - `name`
  - `seasonDates`
  - `city`
  - `state`
  - `zip`
- `location` (`city`, `state` for request `lat`, `lng`)

Request:
```
query {
  marketsByCoords(lat: 39.7589478, lng: -84.1916069, radius: 50, products: ["bakedgoods", "cheese"]) {
    markets {
      marketname
      products {
        name
      }
    }
    location
  }
}
```
Response:
```
{
  "data": {
    "marketsByCoords": {
      "markets": [
        {
          "marketname": "2nd Street Market - Five Rivers MetroPark",
          "products": [
            {
              "name": "organic"
            },
            {
              "name": "bakedgoods"
            },
            {
              "name": "cheese"
            },
            {
              "name": "crafts"
            },
            {
              "name": "flowers"
            },
            {
              "name": "eggs"
            },
            {
              "name": "herbs"
            },
            {
              "name": "vegetables"
            },
            {
              "name": "honey"
            },
            {
              "name": "jams"
            },
            {
              "name": "maple"
            },
            {
              "name": "meat"
            },
            {
              "name": "nuts"
            },
            {
              "name": "plants"
            },
            {
              "name": "poultry"
            },
            {
              "name": "prepared"
            },
            {
              "name": "soap"
            },
            {
              "name": "coffee"
            },
            {
              "name": "beans"
            },
            {
              "name": "fruits"
            },
            {
              "name": "grains"
            },
            {
              "name": "juices"
            },
            {
              "name": "mushrooms"
            },
            {
              "name": "petfood"
            },
            {
              "name": "wildharvested"
            }
          ]
        }
        ],
        "location": "Dayton, Ohio"
    }
  }
}
```
### marketsByCity
[queries](#queries)

Retrieves markets within `x` radius of `city`, `state`.
Optional arguments include `products` and `date`.
- `products` takes an array of strings where each string is a product offering to filter the returning markets by
- `date` takes a single date and returns markets sorted by the nearest matching date

Optional return attributes (must include at least 1):
- `markets`
  - `closestDate` (if given optional `date` arg)
  - `distance`
  - `id`
  - `latitude`
  - `longitude`
  - `marketname`
  - `products`
    - `name`
  - `seasonDates`
  - `city`
  - `state`
  - `zip`
- `latitude` (longitude of the request `city`, `state`)
- `longitude` (latitude of the request `city`, `state`)

Request:
```
query {
	marketsByCity(city: "Dayton", state:"Ohio", radius: 50, date: "08/02/2020") {
    markets {
     marketname seasonDates distance closestDate
    }
    latitude
    longitude
  }
}
```
Response:
```
{
  "data": {
    "marketsByCity": {
      "markets": [
        {
          "marketname": "Hyde Park Farmers' Market",
          "seasonDates": "05/17/2020 to 10/25/2020, Sun: 9:30 AM-1:30 PM;",
          "distance": 44.83456875109411,
          "closestDate": "August 02, 2020"
        },
        {
          "marketname": "Fibonacci's Mount Healthy Farmers Market",
          "seasonDates": "05/03/2020 to 11/01/2020, Sun: 11:00 AM-2:00 PM;",
          "distance": 40.92032550147329,
          "closestDate": "August 02, 2020"
        }
        ],
        "latitude": 39.7589478,
        "longitude": -84.1916069
    }
  }
}
```
### marketsByDate
[queries](#queries)

Retrieves markets nearest a given `date`.

Optional market return attributes (must include at least 1):
- `closestDate`
- `id`
- `latitude`
- `longitude`
- `marketname`
- `products`
  - `name`
- `seasonDates`
- `city`
- `state`
- `zip`

Request:
```
query {
  marketsByDate(date: "08/02/2020") {
    marketname seasonDates closestDate
 }
}

```
Response:
```
{
  "data": {
    "marketsByDate": [
      {
        "marketname": "San Marcos Certified Farmers' Market",
        "seasonDates": "01/01/2020 to 12/31/2020, Sun: 11:00 AM-3:00 PM;",
        "closestDate": "August 02, 2020"
      },
      {
        "marketname": "Paterson Market Growers, Inc.",
        "seasonDates": "01/01/2020 to 12/31/2020, Mon: 7:00 AM-8:00 PM;Tue: 7:00 AM-8:00 PM;Wed: 7:00 AM-8:00 PM;Thu: 7:00 AM-8:00 PM;Fri: 7:00 AM-8:00 PM;Sat: 7:00 AM-8:00 PM;Sun: 7:00 AM-8:00 PM;",
        "closestDate": "August 02, 2020"
      }
    ]
  }
}
```
***
## Tech Stack
[top](#us-farmers-markets-api)
* Ruby 2.5.3
* Rails 5.2.4
* GraphQL
* RSpec
* [Geocoder Gem](https://github.com/alexreisner/geocoder)

***
## Contributors
[top](#us-farmers-markets-api)
* [Tyler Porter](https://github.com/tylerpporter)
* [Zach Holcomb](https://github.com/zachholcomb)
* [Colin Alexander](https://github.com/coloniusrex)
![DevelopmentTeam](app/assets/images/team_index_USFM_api.png)

