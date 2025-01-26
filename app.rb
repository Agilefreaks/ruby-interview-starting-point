# frozen_string_literal: true

require 'roda'

class App < Roda
  route do |r|
    r.on 'api' do
      r.on 'v1' do
        r.run Api::V1::BaseRoute
      end
    end
  end
end
