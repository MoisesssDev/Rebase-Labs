require 'sinatra'
require 'rack/handler/puma'
require 'csv'

get '/tests' do
  rows = CSV.read("./data/data.csv", col_sep: ';')

  columns = rows.shift

  rows.map do |row|
    row.each_with_object({}).with_index do |(cell, acc), idx|
      column = columns[idx]
      acc[column] = cell
    end
  end.to_json
end

get '/hello' do
  'Hello world!'
end