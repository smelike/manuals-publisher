source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.3'
# Use mongoid as the database for Active Record
# TODO upgrade eventually
gem "mongoid", "4.0.0"
gem "mongoid_rails_migrations", "1.0.0"
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'unicorn', '~> 4.9.0'
gem 'logstasher', '0.6.2'

group :development do
  gem 'meta_request'
  gem 'better_errors'
  gem 'binding_of_caller'
end


group :development, :test do
  gem 'rspec-rails', '~> 3.3'
  gem 'simplecov', '0.10.0', require: false
  gem 'simplecov-rcov', '0.2.3', require: false
  gem 'database_cleaner', '1.5.0'
  gem 'pry-byebug'
  gem 'web-console', '~> 2.0'
  gem "capybara", "2.5.0"
  gem 'capybara-webkit', '1.7.1'
  gem 'factory_girl'
end


gem 'airbrake', '~> 4.2.1'
gem 'gds-sso', '11.0.0'
gem 'govuk_admin_template', '1.0.0'
gem 'plek', '~> 1.10'

if ENV["GOVSPEAK_DEV"]
  gem "govspeak", :path => "../govspeak"
else
  gem "govspeak", "3.4.0"
end

if ENV["API_DEV"]
  gem "gds-api-adapters", :path => "../gds-api-adapters"
else
  gem "gds-api-adapters", "24.4.0"
end

gem "foreman", "0.74.0"
gem "select2-rails",  "4.0.0"
