require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require 'pg'
require 'securerandom'
require_relative 'lib/format_response'
require_relative 'lib/queries_SQL'
require_relative 'jobs/import_csv_job'
require_relative 'lib/csv_file'

DATA_DIR = 'data'.freeze
Dir.mkdir(DATA_DIR) unless File.directory?(DATA_DIR)

get '/api/v1/tests' do
  conn = connect_to_database

  begin 
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
  conn = connect_to_database
  result = find_by_token(conn, params[:token])

  content_type :json
  response.headers['Access-Control-Allow-Origin'] = '*'
  format_response(result).to_json
end

post '/api/v1/import_csv' do
  if params[:file] && (tempfile = params[:file][:tempfile])
    
    begin
      file_path = CsvFile.save_temp_file(tempfile)
      ImportCsvJob.perform_async(file_path)
      status 202 
      { status: 'success', message: 'O arquivo CSV está sendo processado. Por favor, aguarde.' }.to_json

    rescue StandardError => e
      status 500 
      { status: 'error', message: "Ocorreu um erro durante o processamento do arquivo CSV: #{e.message}" }.to_json   
    end

  else
    status 400 
    { status: 'error', message: 'Erro: Nenhum arquivo enviado.' }.to_json
  end
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
  create_tables(PG.connect(dbname: 'rebaselabs', user: 'docker', password: 'docker', host: 'pgserver'))
  Rack::Handler::Puma.run(Sinatra::Application, Port: 3000, Host: '0.0.0.0')
end
