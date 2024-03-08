require 'csv'
require 'benchmark'
require 'pg'
require_relative 'queries_SQL'

def read_csv(csv_file)
  CSV.read(csv_file, col_sep: ';', headers: true)
end

def import_data(conn, csv_file)
  puts 'Iniciando criação de tabelas...'
  create_tables(conn)
  puts 'Tabelas criadas com sucesso!'

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

puts 'Iniciando importação...'
time = Benchmark.realtime do
  conn = PG.connect(conn_params)
  import_data(conn, csv_file)
  conn.close
end

puts 'Importação concluída com sucesso!'
puts "Tempo de execução: #{time.round(2)} segundos"
