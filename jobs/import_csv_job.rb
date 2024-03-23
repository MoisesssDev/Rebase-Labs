require_relative '../lib/import_from_csv'
require_relative '../lib/queries_SQL'
require 'sidekiq'

class ImportCsvJob
  include Sidekiq::Job

  def perform(csv_file)
    conn = connect_to_database
    import_data(conn, csv_file)
    conn.close
  end
end

