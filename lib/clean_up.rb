require_relative 'schema'
require 'pg'
require 'fileutils'

def delete_database(config_database)
  conn = PG.connect(config_database)
  Schema.drop_tables(conn)
  conn.close
end

CONFIG_DATABASE = [
                    { dbname: 'rebaselabs', user: 'docker', password: 'docker', host: 'pgserver' }, 
                    { dbname: 'rebasetest', user: 'docker', password: 'docker', host: 'pgtest' }
                  ]

CONFIG_DATABASE.each do |config_database|
  begin
    delete_database(config_database)
  rescue PG::Error => e
    puts e.message
  end
end

FileUtils.rm_rf('data')

puts 'Banco de dados e arquivos de dados removidos com sucesso!'