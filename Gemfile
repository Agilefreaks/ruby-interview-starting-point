# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.1'

# Use Puma as the app server
gem 'csv'
gem 'http'
gem 'irb'
gem 'logger'
gem 'puma', '~> 6.5'
gem 'rack'
gem 'rack-cors'
gem 'roda'
gem 'zeitwerk', '~> 2.6'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv'
  gem 'listen'
  gem 'rspec', '~> 3.10'
end

group :development do
  gem 'rubocop', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
