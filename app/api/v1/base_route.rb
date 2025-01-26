# frozen_string_literal: true

require 'permit_params'

module Api
  module V1
    class BaseRoute < Roda
      plugin :json
      plugin :error_handler
      plugin :permit_params

      route do |r|
        r.on 'closest_coffee_shops' do
          r.run Api::V1::CoffeeShopsRoute
        end
      end

      error do |e|
        response.status = 500
        { error: e.message }
      end
    end
  end
end
