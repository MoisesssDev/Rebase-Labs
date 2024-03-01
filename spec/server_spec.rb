ENV['APP_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require_relative '../server'

describe 'Server' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'retorna hello world' do
    get '/hello'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello world!')
  end

  it 'should return tests' do
    get '/tests'
    expect(last_response).to be_ok
  end
end