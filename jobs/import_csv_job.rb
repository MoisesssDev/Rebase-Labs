require_relative '../lib/import_from_csv'
require 'sidekiq'

class ImportCsvJob
  include Sidekiq::Job

  def perform(csv_file)
    conn = PG.connect(dbname: 'rebaselabs', user: 'docker', password: 'docker', host: 'pgserver')
    import_data(conn, csv_file)
    conn.close
  end
end
