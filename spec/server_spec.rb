ENV['APP_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require_relative '../server'

describe 'Roda o servidor' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'e retorna hello world' do
    get '/hello'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello world!')
  end

  it 'e ver os dados com sucesso' do
    get '/tests'
    expect(last_response).to be_ok
    expect(last_response.content_type).to eq('application/json')
    expect(JSON.parse(last_response.body)).to include([{"cpf":"048.973.170-88","nome_paciente":"Emilly Batista Neto",
                                                        "email_paciente":"gerald.crona@ebert-quigley.com",
                                                        "data_nascimento_paciente":"2001-03-11","endereco_rua_paciente":"165 Rua Rafaela",
                                                        "cidade_paciente":"Ituverava","estado_patiente":"Alagoas","crm_medico":"B000BJ20J4",
                                                        "crm_medico_estado":"PI","nome_medico":"Maria Luiza Pires","email_medico":"denna@wisozk.biz",
                                                        "token_resultado_exame":"IQCZ17","data_exame":"2021-08-05","tipo_exame":"hemácias",
                                                        "limites_tipo_exame":"45-52","resultado_tipo_exame":"97"}])
  end
end