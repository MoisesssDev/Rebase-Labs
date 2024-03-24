require_relative '../lib/csv_file'
require_relative '../lib/schema'
require 'sidekiq'

class ImportCsvJob
  include Sidekiq::Job

  def perform(csv_file)
    conn = Schema.connect_to_database
    CsvFile.import_data(conn, csv_file)
    conn.close
  end
end

