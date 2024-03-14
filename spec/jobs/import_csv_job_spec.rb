require 'spec_helper'
require_relative '../../jobs/import_csv_job'

describe '#perform' do
  it 'importa arquivo CSV com sucesso' do
    file_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'csv', 'data_sucess.csv')
    csv_file = File.read(file_path)

    ImportCsvJob.perform(csv_file)
    # conn = PG.connect(dbname: 'rebase-db', user: 'rebase', password: 'rebase', host: 'rebase-postgres')
    # result = find_by_token(conn, 'IQCZ17')

    # expect(result.ntuples).to eq(1)
    # expect(result[0]['result_token']).to eq('IQCZ17')
    # expect(result[0]['result_date']).to eq('2021-08-05')
    # expect(result[0]['cpf']).to eq('048.973.170-88')
    # expect(result[0]['name']).to eq('Emilly Batista Neto')
    # expect(result[0]['email']).to eq('gerald.crona@ebert-quigley.com')
    # expect(result[0]['birthdate']).to eq('2001-03-11')
  end
end