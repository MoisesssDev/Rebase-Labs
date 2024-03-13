ENV['APP_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require_relative '../server'
require_relative '../lib/import_from_csv'

def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end