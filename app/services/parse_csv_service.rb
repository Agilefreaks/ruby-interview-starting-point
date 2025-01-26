# frozen_string_literal: true

require 'csv'
require 'logger'

module Services
  class ParseCsvService
    def initialize(csv_data)
      @csv_data = csv_data
    end

    def call
      rows = CSV.parse(@csv_data, headers: false)
      rows.map do |row|
        validate_row(row)
      end.compact
    rescue CSV::MalformedCSVError => e
      raise "Error parsing CSV: #{e.message}"
    end

    private

    def validate_row(row)
      name, y, x = row

      if name.nil? || y.nil? || x.nil?
        Logger.new($stdout).warn("Malformed row in CSV: #{row}")
        nil
      else
        { name: name.strip, y: y.to_f, x: x.to_f }
      end
    end
  end
end
