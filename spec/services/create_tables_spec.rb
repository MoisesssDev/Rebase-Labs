require 'spec_helper'
require 'pg'

describe 'Criação da tabela' do

  it 'de médicos com sucesso' do
    conn = PG.connect(dbname: 'rebase-db', user: 'rebase', password: 'rebase', host: 'rebase-postgres')
    result = conn.exec('SELECT * FROM doctors')
    expect(result.fields).to eq(['crm', 'crm_state', 'name', 'email'])
  end

  it 'de pacientes com sucesso' do
    conn = PG.connect(dbname: 'rebase-db', user: 'rebase', password: 'rebase', host: 'rebase-postgres')
    result = conn.exec('SELECT * FROM patients')
    expect(result.fields).to eq(['cpf', 'name', 'email', 'birthdate', 'address', 'city', 'state'])
  end

  it 'de exames com sucesso' do
    conn = PG.connect(dbname: 'rebase-db', user: 'rebase', password: 'rebase', host: 'rebase-postgres')
    result = conn.exec('SELECT * FROM tests')
    expect(result.fields).to eq(['patient_cpf', 'doctor_crm', 'result_token', 'result_date', 'exam_type', 'exam_type_limits', 'exam_type_result'])
  end
end