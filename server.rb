require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require 'pg'
require_relative 'lib/format_response'
require_relative 'lib/queries_SQL'
require_relative 'jobs/import_csv_job'

get '/api/v1/tests' do
  begin 
    conn = PG.connect(dbname: 'rebase-db', user: 'rebase', password: 'rebase', host: 'rebase-postgres')
    result = find_all(conn)

    content_type :json
    response.headers['Access-Control-Allow-Origin'] = '*'
    format_response(result).to_json
  rescue PG::Error => e
    content_type :json
    [].to_json
  ensure
    conn.close if conn
  end
end

get '/api/v1/tests/:token' do
  conn = PG.connect(dbname: 'rebase-db', user: 'rebase', password: 'rebase', host: 'rebase-postgres')
  result = find_by_token(conn, params[:token])

  content_type :json
  response.headers['Access-Control-Allow-Origin'] = '*'
  format_response(result).to_json
end

post '/api/v1/import_csv' do
  begin
    csv_file = params[:file][:tempfile]
    ImportCsvJob.perform(csv_file)

    status 202
    content_type :json
    { message: "O arquivo CSV está sendo processado. Por favor, aguarde." }.to_json
  rescue PG::Error => e
    status 500
    content_type :json
    { error: "Erro no banco de dados: #{e.message}" }.to_json
  rescue StandardError => e
    status 500
    content_type :json
    { error: "Ocorreu um erro durante o processamento do arquivo CSV: #{e.message}" }.to_json
  end

  redirect '/'
end

get '/' do
  content_type 'text/html'
  File.open(File.join('public/views', 'index.html'))
end

get '/:token' do
  content_type 'text/html'
  File.open(File.join('public/views', 'show.html'))
end

if ENV['APP_ENV'] != 'test'
  create_tables(PG.connect(dbname: 'rebase-db', user: 'rebase', 'password': 'rebase', host: 'rebase-postgres'))
  Rack::Handler::Puma.run(Sinatra::Application, Port: 3000, Host: '0.0.0.0')
end
