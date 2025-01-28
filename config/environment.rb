# frozen_string_literal: true

require 'yaml'
require 'logger'

APP_CONFIG = YAML.load_file(File.join(__dir__, 'settings.yml')).transform_keys(&:to_sym)
APP_LOGGER = Logger.new($stdout)

Dir[File.join(__dir__, '../app/**/*.rb')].each { |file| require file }
