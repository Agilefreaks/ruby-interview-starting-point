# frozen_string_literal: true

require 'bundler/setup'
require 'rack/cors'
require 'zeitwerk'
require 'roda'

$LOAD_PATH.unshift(File.expand_path('app/roda_plugins', __dir__))
$LOAD_PATH.unshift(File.expand_path(__dir__))

loader = Zeitwerk::Loader.new

loader.push_dir(File.expand_path('app', __dir__))
loader.enable_reloading if ENV.fetch('RACK_ENV', nil) == 'development'
loader.setup

configure_cors = proc do
  use Rack::Cors do
    allow do
      origins ENV.fetch('RACK_CORS_ORIGIN', nil) || '*'
      resource ENV.fetch('RACK_CORS_RESOURCE', nil) || '*',
               headers: :any,
               methods: %i[get post options put delete]
    end
  end
end

require_relative 'app'

case ENV.fetch('RACK_ENV', nil)
when 'production', 'staging'
  loader.eager_load
  instance_eval(&configure_cors)
  run App.freeze.app
when 'test'
  require 'byebug'
  require 'dotenv/load'
  loader.eager_load
  instance_eval(&configure_cors)
  run App.freeze.app
else
  require 'byebug'
  require 'dotenv/load'

  app = Rack::Builder.new do
    instance_eval(&configure_cors)
    run App
  end

  loader.log!

  require 'listen'
  Listen.to(File.expand_path('app', __dir__)) do
    loader.reload
  end.start

  run app
end
