     
require 'sinatra'
require 'pry'
require 'soda/client'
require 'sinatra/reloader'

get '/' do


  client = SODA::Client.new({:domain => "data.melbourne.vic.gov.au"})

  @results = client.get("qnjw-wgaj", :$limit => 5000)

  # puts "Got #{results.count} results. Dumping first results:"
  # results.first.each do |k, v|
  #   puts "#{k}: #{v}"
  # end

  erb :index
end





