# frozen_string_literal: true

require 'haml'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/param'
require 'net/http'
require 'uri'

module CoffeeShop
  class App < Sinatra::Base
    helpers Sinatra::Param

    get '/' do
      @coffee_shops = read_coffee_shop_csv
      haml :index
    end

    get '/search' do
      unless params[:latitude].nil? && params[:longitude].nil?
        param :latitude, Float, min: -90, max: 90, required: true
        param :longitude, Float, min: -180, max: 180, required: true

        @latitude = params[:latitude]
        @longitude = params[:longitude]
        @coffee_shops = nearest({ latitude: params[:latitude], longitude: params[:longitude] }, read_coffee_shop_csv)
      end

      haml :search
    end

    private

    def read_coffee_shop_csv
      url = 'https://raw.githubusercontent.com/Agilefreaks/test_oop/master/coffee_shops.csv'
      coffee_shops = Net::HTTP.get(URI.parse(url))

      return unless coffee_shops

      csv_data = coffee_shops.split("\n").map { |line| line.split(',') }
      csv_data.map do |elem|
        { name: elem[0], latitude: elem[1].to_f, longitude: elem[2].to_f }
      end
    end
  end
end
