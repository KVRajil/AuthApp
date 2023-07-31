source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

gem 'rails', '~> 7.0.6'

gem 'pg'

gem 'puma', '~> 5.0'

gem 'bootsnap', require: false

gem 'bcrypt'
gem 'jwt'
gem 'rotp'

gem 'rack-cors', '~> 1.1'

gem 'apipie-rails', '~> 0.8.2'

group :development do
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
end

group :test do
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'simplecov'
  gem 'spring'
end
