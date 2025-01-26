# frozen_string_literal: true

require 'open-uri'
require 'net/http'
require 'byebug'

module Services
  class FetchCsvService
    def initialize(url)
      @url = url
    end

    def call
      uri = URI.parse(@url)
      response = Net::HTTP.get_response(uri)
      raise "#{response.code} #{response.message}" unless response.is_a?(Net::HTTPOK)

      response.body
    rescue StandardError => e
      raise "Error fetching CSV: #{e.message}"
    end
  end
end
