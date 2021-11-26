require 'spec_helper'
require_relative '../lib/csv_parser'

RSpec.describe CsvParser, method: :get_data do

  let(:url) { URI.parse('https://raw.githubusercontent.com/Agilefreaks/test_oop/master/coffee_shops.csv') }
  let(:instance) { CsvParser.new(url) }

  subject(:csv_parser_data) { instance.get_data }

  it 'returns array with parsed data' do

    # .to raise_exception(RuntimeError) .not_to be_empty

    expect(csv_parser_data).not_to be_empty
    expect(csv_parser_data.count).to eq 6

  end

end
