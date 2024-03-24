require_relative '../lib/csv_file'
require_relative '../lib/queries_SQL'
require 'sidekiq'

class ImportCsvJob
  include Sidekiq::Job

  def perform(csv_file)
    conn = connect_to_database
    CsvFile.import_data(conn, csv_file)
    conn.close
  end
end

