require 'spec_helper'

describe 'Importa dados do CSV' do

  it 'para a tabela de tests com sucesso' do
    conn = PG.connect(dbname: 'rebase-db', user: 'rebase', password: 'rebase', host: 'rebase-postgres')
    import_data(conn, 'spec/support/assets/csv/data_sucess.csv')

    result = conn.exec('SELECT * FROM tests')
    expect(result.count).to eq(3900)
    expect(result[0]['patient_cpf']).to eq('048.973.170-88')
    expect(result[0]['doctor_crm']).to eq('B000BJ20J4')
    expect(result[0]['result_token']).to eq('IQCZ17')
    expect(result[0]['result_date']).to eq('2021-08-05')
    expect(result[0]['exam_type']).to eq('hemácias')
    expect(result[0]['exam_type_limits']).to eq('45-52')
    expect(result[0]['exam_type_result']).to eq('97')

    drop_tables(conn)
    conn.close
  end

  it 'para a tabela de doctors com sucesso' do
    conn = PG.connect(dbname: 'rebase-db', user: 'rebase', password: 'rebase', host: 'rebase-postgres')
    import_data(conn, 'spec/support/assets/csv/data_sucess.csv')

    result = conn.exec('SELECT * FROM doctors')
    expect(result.count).to eq(9)
    expect(result[0]['crm']).to eq('B000BJ20J4')
    expect(result[0]['crm_state']).to eq('PI')
    expect(result[0]['name']).to eq('Maria Luiza Pires')
    expect(result[0]['email']).to eq('denna@wisozk.biz')

    drop_tables(conn)
    conn.close
  end

  it 'para a tabela de patients com sucesso' do
    conn = PG.connect(dbname: 'rebase-db', user: 'rebase', password: 'rebase', host: 'rebase-postgres')
    import_data(conn, 'spec/support/assets/csv/data_sucess.csv')

    result = conn.exec('SELECT * FROM patients')
    expect(result.count).to eq(50)
    expect(result[0]['cpf']).to eq('048.973.170-88')
    expect(result[0]['name']).to eq('Emilly Batista Neto')
    expect(result[0]['email']).to eq('gerald.crona@ebert-quigley.com')
    expect(result[0]['birthdate']).to eq('2001-03-11')
    expect(result[0]['address']).to eq('165 Rua Rafaela')
    expect(result[0]['city']).to eq('Ituverava')
    expect(result[0]['state']).to eq('Alagoas')

    drop_tables(conn)
    conn.close
  end

end