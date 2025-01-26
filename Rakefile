# frozen_string_literal: true

require 'rake'
require 'bundler/setup'
require 'roda'
require 'irb'
require 'zeitwerk'
require 'dotenv/load'

desc 'Start interactive console'
task :console do
  $LOAD_PATH.unshift(File.expand_path('app/roda_plugins', __dir__))
  $LOAD_PATH.unshift(File.expand_path(__dir__))

  loader = Zeitwerk::Loader.new
  loader.push_dir(File.expand_path('app', __dir__))
  loader.setup

  # Ensure all files are loaded
  loader.eager_load

  ARGV.clear
  IRB.start
end

desc 'Run the server'
task :server do
  sh 'bundle exec rackup'
end
