# frozen_string_literal: true

require 'spec_helper'
require 'ruby_interview' # it knows that is in lib directory

RSpec.describe RubyInterview, method: :call do
  subject(:ruby_interview) { instance.call }

  let(:instance) { RubyInterview.new }

  it 'responds with Good luck!' do
    expect(ruby_interview).to eq 'Good luck!'
  end
end
