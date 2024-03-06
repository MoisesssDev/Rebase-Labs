ENV['APP_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require_relative '../server'

def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end