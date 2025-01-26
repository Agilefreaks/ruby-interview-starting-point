# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Services::ParseCsvService, method: :call do
  context 'when the request is successful' do
    let(:csv_data) { "Starbucks Seattle,47.61,-122.33\nStarbucks San Francisco,37.77,-122.42" }
    let(:parse_csv_service_instance) { Services::ParseCsvService.new(csv_data) }

    it 'CSV file should include Starbucks' do
      expect(parse_csv_service_instance.call).to be_a(Array)
      expect(parse_csv_service_instance.call.first[:name]).to eq 'Starbucks Seattle'
      expect(parse_csv_service_instance.call.size).to be > 0
      expect(parse_csv_service_instance.call.first).to be_a(Hash)
      expect(parse_csv_service_instance.call.first.keys).to include(:name, :x, :y)
    end
  end
end
