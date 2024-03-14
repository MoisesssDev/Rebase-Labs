require 'spec_helper'
require 'pg'

describe 'Criação da tabela' do
  before(:all) do
    @conn = PG.connect(dbname: 'rebaselabs', user: 'docker', password: 'docker', host: 'pgserver')
    create_tables(@conn)
  end

  it 'de médicos com sucesso' do
    result = @conn.exec('SELECT * FROM doctors')
    
    expect(result.fields).to eq(['crm', 'crm_state', 'name', 'email'])
  end

  it 'de pacientes com sucesso' do
    result = @conn.exec('SELECT * FROM patients')

    expect(result.fields).to eq(['cpf', 'name', 'email', 'birthdate', 'address', 'city', 'state'])
  end

  it 'de exames com sucesso' do
    result = @conn.exec('SELECT * FROM tests')
    
    expect(result.fields).to eq(['patient_cpf', 'doctor_crm', 'result_token', 'result_date', 
                                 'exam_type', 'exam_type_limits', 'exam_type_result'])
  end

  after(:all) do
    drop_tables(@conn)
    @conn.close
  end
end
