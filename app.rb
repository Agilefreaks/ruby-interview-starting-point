# frozen_string_literal: true

# app.rb
require_relative 'config/environment'

# Mount the controller
map '/api' do
  run CoffeeShopController
end
