require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require 'pg'

get '/tests' do
  conn = PG.connect(dbname: 'rebase-db', user: 'rebase', password: 'rebase', host: 'rebase-postgres')

  result = conn.exec('
    SELECT
      t.result_token, t.result_date, p.cpf, p.name, p.email, p.birthdate,
      d.crm, d.crm_state, d.name AS doctor_name,
      t.exam_type AS type, t.exam_type_limits AS limits, t.exam_type_result AS result
    FROM tests t
    JOIN doctors d ON t.doctor_crm = d.crm
    JOIN patients p ON t.patient_cpf = p.cpf
  ')

  content_type :json
  format_response(result).to_json
end

def format_response(result)
  patients = []
  current_patient = nil

  result.each do |row|
    if current_patient.nil? || current_patient['cpf'] != row['cpf']
      current_patient = {
        'result_token' => row['result_token'],
        'result_date' => row['result_date'],
        'cpf' => row['cpf'],
        'name' => row['name'],
        'email' => row['email'],
        'birthday' => row['birthdate'],
        'doctor' => {
          'crm' => row['crm'],
          'crm_state' => row['crm_state'],
          'name' => row['doctor_name']
        },
        'tests' => []
      }
      patients << current_patient
    end

    current_patient['tests'] << {
      'type' => row['type'],
      'limits' => row['limits'],
      'result' => row['result']
    }
  end

  patients
end

get '/hello' do
  'Hello world!'
end

if ENV['APP_ENV'] != 'test'
  Rack::Handler::Puma.run(Sinatra::Application, Port: 3000, Host: '0.0.0.0')
end
