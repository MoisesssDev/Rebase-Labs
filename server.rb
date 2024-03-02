require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require 'pg'

get '/tests' do
  conn = PG.connect(dbname: 'rebase-db', user: 'rebase', password: 'rebase', host: 'rebase-postgres')

  result = conn.exec('SELECT * FROM tests;')

  content_type :json
  result.map { |row| row.to_h }.to_json
end

get '/hello' do
  'Hello world!'
end

if ENV['APP_ENV'] != 'test'
  Rack::Handler::Puma.run(Sinatra::Application, Port: 3000, Host: '0.0.0.0')
end
