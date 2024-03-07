require 'csv'
require 'benchmark'
require 'pg'
require_relative 'create_tables'

def read_csv(csv_file)
  CSV.read(csv_file, col_sep: ';', headers: true)
end

def insert_patient(conn, row)
  conn.exec_params("INSERT INTO patients VALUES ($1, $2, $3, $4, $5, $6, $7) ON CONFLICT DO NOTHING", row[0..6])
  row[0]
end

def insert_doctor(conn, row)
  conn.exec_params("INSERT INTO doctors VALUES ($1, $2, $3, $4) ON CONFLICT DO NOTHING", row[7..10])
  row[7]
end

def insert_test(conn, row, patient_cpf, doctor_crm)
  conn.exec_params("INSERT INTO tests VALUES ($1, $2, $3, $4, $5, $6, $7)", row[11..15].unshift(patient_cpf, doctor_crm))
end

def import_data(conn, csv_file)
  create_tables(conn)

  patient_cpf, doctor_crm = nil, nil

  conn.transaction do
    read_csv(csv_file).each do |row|
      patient_cpf = insert_patient(conn, row)
      doctor_crm = insert_doctor(conn, row)
      insert_test(conn, row, patient_cpf, doctor_crm)
    end
  end
end

conn_params = { dbname: 'rebase-db', user: 'rebase', password: 'rebase', host: 'rebase-postgres' }
csv_file = './data/data.csv'

time = Benchmark.realtime do
  conn = PG.connect(conn_params)
  import_data(conn, csv_file)
  conn.close
end

puts "Tempo de execução: #{time.round(2)} segundos"
puts 'Importação concluída com sucesso!'
