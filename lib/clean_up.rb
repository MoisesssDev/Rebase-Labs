require_relative 'queries_SQL'
require 'pg'
require 'fileutils'

conn = PG.connect(dbname: 'rebaselabs', user: 'docker', password: 'docker', host: 'pgserver')
drop_tables(conn)
conn.close

FileUtils.rm_rf('data')

puts 'Banco de dados e arquivos de dados removidos com sucesso!'