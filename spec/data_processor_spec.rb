require 'spec_helper'
require_relative '../lib/data_processor'

RSpec.describe DataProcessor, method: :get_closest_shops do

  let(:user_x) { 47.6 }
  let(:user_y) { -122.42 }
  let(:url) { 'https://raw.githubusercontent.com/Agilefreaks/test_oop/master/coffee_shops.csv' }


  it 'outputs message for invalid user coordinates' do

    data_processor = DataProcessor.new('abc', user_y, url)
    expect {
      closest_shops_array = data_processor.get_closest_shops(3)
    }.to output("Please provide valid coordinates\n").to_stdout

  end


  it 'returns array with closest shops' do

    data_processor = DataProcessor.new(user_x, user_y, url)
    closest_shops_array = data_processor.get_closest_shops(3)

    expect(closest_shops_array).not_to be_empty
    expect(closest_shops_array.count).to eq 3

  end

end
