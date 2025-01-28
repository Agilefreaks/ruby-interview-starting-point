# frozen_string_literal: true

require_relative 'app'

map '/api' do
  run CoffeeShopController
end
