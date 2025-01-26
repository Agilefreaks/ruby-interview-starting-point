# frozen_string_literal: true

module Api
  module V1
    class CoffeeShopsRoute < BaseRoute
      route do |r|
        r.get do
          permit_params = permit_params(r.params, %w[x y])
          puts permit_params
        end
      end
    end
  end
end
