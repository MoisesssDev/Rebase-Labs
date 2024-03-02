require 'csv'
require 'pg'


conn = PG.connect(dbname: 'rebase-db', user: 'rebase', password: 'rebase', host: 'rebase-postgres')


conn.exec("CREATE TABLE IF NOT EXISTS tests (
            cpf VARCHAR(15),
            nome_paciente VARCHAR(255),
            email_paciente VARCHAR(255),
            data_nascimento_paciente DATE,
            endereco_rua_paciente VARCHAR(255),
            cidade_paciente VARCHAR(255),
            estado_paciente VARCHAR(255),
            crm_medico VARCHAR(20),
            crm_medico_estado VARCHAR(2),
            nome_medico VARCHAR(255),
            email_medico VARCHAR(255),
            token_resultado_exame VARCHAR(10),
            data_exame DATE,
            tipo_exame VARCHAR(255),
            limites_tipo_exame VARCHAR(255),
            resultado_tipo_exame VARCHAR(255)
          );")


CSV.foreach("./data/data.csv", col_sep: ';', headers: true) do |row|
  conn.exec_params("INSERT INTO tests VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)",
                   row.fields)
end

puts 'Importação concluída com sucesso!'

conn.close
