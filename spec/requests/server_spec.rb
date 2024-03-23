require 'spec_helper'

describe 'Roda o servidor' do

  before(:all) do
    @conn = PG.connect(dbname: 'rebasetest', user: 'docker', password: 'docker', host: 'pgtest')
    create_tables(@conn)
  end

  after(:all) do
    @conn.close
  end

  context 'GET api/v1/tests/:token' do
    it 'e o token não existe' do
      import_data(@conn, 'spec/support/assets/csv/data_sucess.csv')

      get 'api/v1/tests/123'

      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(last_response.body).to eq('[]')
      drop_tables(@conn)
    end


    it 'e ver apenas um resultado com sucesso' do
      import_data(@conn, 'spec/support/assets/csv/data_sucess.csv')

      get 'api/v1/tests/IQCZ17'

      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expected_json = [{
                        "result_token" => "IQCZ17",
                        "result_date" => "2021-08-05",
                        "cpf" => "048.973.170-88",
                        "name" => "Emilly Batista Neto",
                        "email" => "gerald.crona@ebert-quigley.com",
                        "birthday" => "2001-03-11",
                        "doctor" => {
                          "crm" => "B000BJ20J4",
                          "crm_state" => "PI",
                          "name" => "Maria Luiza Pires"
                        },
                        "tests" => [
                          { "type" => "hemácias", "limits" => "45-52", "result" => "97" },
                          { "type" => "leucócitos", "limits" => "9-61", "result" => "89" },
                          { "type" => "plaquetas", "limits" => "11-93", "result" => "97" },
                          { "type" => "hdl", "limits" => "19-75", "result" => "0" },
                          { "type" => "ldl", "limits" => "45-54", "result" => "80" },
                          { "type" => "vldl", "limits" => "48-72", "result" => "82" },
                          { "type" => "glicemia", "limits" => "25-83", "result" => "98" },
                          { "type" => "tgo", "limits" => "50-84", "result" => "87" },
                          { "type" => "tgp", "limits" => "38-63", "result" => "9" },
                          { "type" => "eletrólitos", "limits" => "2-68", "result" => "85" },
                          { "type" => "tsh", "limits" => "25-80", "result" => "65" },
                          { "type" => "t4-livre", "limits" => "34-60", "result" => "94" },
                          { "type" => "ácido úrico", "limits" => "15-61", "result" => "2" }
                        ]
                      }]
      expect(last_response.body).to eq(expected_json.to_json)
      drop_tables(@conn)
    end
  end

  context 'GET api/v1/tests' do
    it 'e não ver nenhum resultado' do
      get 'api/v1/tests'
      
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(last_response.body).to eq('[]')
    end

    it 'e ver todos os resultados com sucesso' do
      import_data(@conn, 'spec/support/assets/csv/data_sucess.csv')

      get 'api/v1/tests'

      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expected_json = {
                        "result_token" => "IQCZ17",
                        "result_date" => "2021-08-05",
                        "cpf" => "048.973.170-88",
                        "name" => "Emilly Batista Neto",
                        "email" => "gerald.crona@ebert-quigley.com",
                        "birthday" => "2001-03-11",
                        "doctor" => {
                          "crm" => "B000BJ20J4",
                          "crm_state" => "PI",
                          "name" => "Maria Luiza Pires"
                        },
                        "tests" => [
                          { "type" => "hemácias", "limits" => "45-52", "result" => "97" },
                          { "type" => "leucócitos", "limits" => "9-61", "result" => "89" },
                          { "type" => "plaquetas", "limits" => "11-93", "result" => "97" },
                          { "type" => "hdl", "limits" => "19-75", "result" => "0" },
                          { "type" => "ldl", "limits" => "45-54", "result" => "80" },
                          { "type" => "vldl", "limits" => "48-72", "result" => "82" },
                          { "type" => "glicemia", "limits" => "25-83", "result" => "98" },
                          { "type" => "tgo", "limits" => "50-84", "result" => "87" },
                          { "type" => "tgp", "limits" => "38-63", "result" => "9" },
                          { "type" => "eletrólitos", "limits" => "2-68", "result" => "85" },
                          { "type" => "tsh", "limits" => "25-80", "result" => "65" },
                          { "type" => "t4-livre", "limits" => "34-60", "result" => "94" },
                          { "type" => "ácido úrico", "limits" => "15-61", "result" => "2" }
                        ]
                      }
      expect(last_response.body).to include(expected_json.to_json)
      drop_tables(@conn)
    end
  end

  context 'POST api/v1/import_csv' do
    it 'e importar dados com sucesso' do
      job_spy = spy('ImportDataJob')
      stub_const('ImportCsvJob', job_spy)

      post 'api/v1/import_csv', file: Rack::Test::UploadedFile.new('spec/support/assets/csv/data_sucess.csv', 'text/csv')

      expect(job_spy).to have_received(:perform_async).once
    end
  end

end
