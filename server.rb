require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require 'pg'
require_relative 'lib/format_response'
require_relative 'lib/database_query'

get '/tests' do
  result = database_query(PG.connect(dbname: 'rebase-db', user: 'rebase', password: 'rebase', host: 'rebase-postgres'))

  content_type :json
  response.headers['Access-Control-Allow-Origin'] = '*'
  format_response(result).to_json
end

get '/hello' do
  'Hello world!'
end

get '/' do
  content_type 'text/html'
  File.open(File.join('public', 'index.html'))
end

get '/styles.css' do
  content_type 'text/css'
  File.open(File.join('public', 'styles.css'))
end

if ENV['APP_ENV'] != 'test'
  Rack::Handler::Puma.run(Sinatra::Application, Port: 3000, Host: '0.0.0.0')
end
