require 'csv'
require 'pg'
require_relative 'schema'

class CsvFile

  def self.save_temp_file(tempfile)
    file_path = "#{DATA_DIR}/#{SecureRandom.hex}.csv"
    File.open(file_path, 'wb') { |file| file.write(tempfile.read) }
    file_path
  end

  def self.import_data(conn, csv_file)
    Schema.create_tables(conn)

    patient_cpf, doctor_crm = nil, nil

    conn.transaction do
      read_csv(csv_file).each do |row|
        patient_cpf = Schema.insert_patient(conn, row)
        doctor_crm = Schema.insert_doctor(conn, row)
        Schema.insert_test(conn, row, patient_cpf, doctor_crm)
      end
    end
  end

  private

  def self.read_csv(csv_file)
    CSV.read(csv_file, col_sep: ';', headers: true)
  end

end
