# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

RSpec.describe Services::FetchCsvService, method: :call do
  let(:url) { ENV['COFFE_SHOPS_LOCATION_URL'] || 'https://raw.githubusercontent.com/Agilefreaks/test_oop/master/coffee_shops.csv' }
  let(:instance) { Services::FetchCsvService.new(url) }
  subject(:fetch_csv_service) { instance.call }

  context 'when the request fails' do
    before do
      stub_request(:get, url).to_return(status: 404, body: 'Not Found')
    end

    it 'raises an error' do
      expect { fetch_csv_service }.to raise_error(RuntimeError, /Error fetching CSV: 404/)
    end
  end

  context 'when an exception occurs' do
    before do
      allow(Net::HTTP).to receive(:get_response).and_raise(StandardError.new('Network error'))
    end

    it 'raises an error' do
      expect { fetch_csv_service }.to raise_error(RuntimeError, /Error fetching CSV: Network error/)
    end
  end
end
