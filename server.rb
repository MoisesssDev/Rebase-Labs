require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require 'pg'
require_relative 'lib/format_response'
require_relative 'lib/database_query'

get '/tests' do
  result = database_query(PG.connect(dbname: 'rebase-db', user: 'rebase', password: 'rebase', host: 'rebase-postgres'))

  content_type :json
  format_response(result).to_json
end

get '/hello' do
  'Hello world!'
end

if ENV['APP_ENV'] != 'test'
  Rack::Handler::Puma.run(Sinatra::Application, Port: 3000, Host: '0.0.0.0')
end
