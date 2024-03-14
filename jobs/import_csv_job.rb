# require 'sidekiq'
require_relative '../lib/import_from_csv'

class ImportCsvJob
  # include Sidekiq::Job

  def self.perform(csv_file)
    puts 'Iniciando importação do CSV...'
    conn = PG.connect(dbname: 'rebase-db', user: 'rebase', password: 'rebase', host: 'rebase-postgres')
    import_data(conn, csv_file)
    conn.close
    puts 'CSV importado com sucesso!'
  end
end
