source 'https://rubygems.org'

ruby '2.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
gem 'bootstrap-sass', '~> 3.1.1'
gem 'angularjs-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'mongoid', github: 'mongoid/mongoid'
gem 'mongoid_slug'
gem 'bson_ext'
gem 'devise'
gem "haml-rails"
gem 'geocoder'
gem 'countries'
gem 'i18n_country_select'

gem 'jquery-ui-rails'
gem 'jquery-ui-themes'
gem 'jquery-tokeninput-rails'

gem 'rmagick', require: false
gem 'carrierwave'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'draper', '~> 1.3'
# gem 'ckeditor' 
gem 'haml_coffee_assets'          # To handle js template
gem 'execjs'
gem 'canvas_admin_rails', :git => 'https://github.com/HouzIO/canvas_admin_rails.git'
# gem 'canvas_admin_rails', :path => '../canvas_admin_rails'
gem 'bootstrap-validator-rails'
gem 'kaminari'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development, :test do
  # Debug
  gem 'pry'

  # Integration
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'selenium-webdriver' 

  gem 'better_errors'               # Better way to show error messages in development
end

group :test do
  gem 'rspec-rails', '~> 3.0.0'
  gem 'factory_girl_rails'          # A fixtures replacement
  gem 'database_cleaner'            # Strategies for cleaning databases in Ruby. Can be used to ensure a clean state for testing
  gem 'mongoid-rspec', '~> 2.0.0.rc1'
  gem 'coveralls', require: false  
end
