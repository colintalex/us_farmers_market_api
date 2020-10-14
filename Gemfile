source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby '2.5.3'
gem 'rails', '~> 5.2.4', '>= 5.2.4.3'
gem 'pg'
gem 'puma', '~> 3.11'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'graphql'
gem 'faraday'
gem 'figaro'
gem 'geocoder'
gem 'simplecov-shield'
gem 'rack-cors'

group :development, :test do
  gem 'rspec-rails'
  gem 'pry'
  gem 'capybara'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'launchy'
  gem 'factory_bot'
  gem 'faker'
  gem 'orderly'
  gem 'webmock'
  gem 'vcr'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "graphiql-rails"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
