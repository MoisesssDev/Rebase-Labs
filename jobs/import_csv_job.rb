require 'sidekiq'
require_relative '../lib/import_from_csv'

class ImportCsvJob
  include Sidekiq::Job

  def perform(csv_file)
    conn = PG.connect(dbname: 'rebase-db', user: 'rebase', password: 'rebase', host: 'rebase-postgres')
    import_data(conn, csv_file)
    conn.close
  end
end
