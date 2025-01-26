# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

RSpec.describe Services::FetchCsvService, method: :call do
  let(:url) { ENV['COFFE_SHOPS_LOCATION_URL'] || 'https://raw.githubusercontent.com/Agilefreaks/test_oop/master/coffee_shops.csv' }
  let(:instance) { Services::FetchCsvService.new(url) }
  subject(:fetch_csv_service) { instance.call }

  context 'when the request is successful' do
    before do
      stub_request(:get, url).to_return(status: 200, body: 'Starbucks Seattle,47.5809,-122.3160')
    end

    it 'returns unparsed the CSV content' do
      expect(fetch_csv_service).to include 'Starbucks'
    end
  end
end
