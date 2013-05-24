require 'sinatra'
require 'haml'
require 'json'

# / index, present user with "new data source, query" and list data sources, queries
get '/' do
  # get data sources from config file
  @data_sources = JSON.parse(IO.read("config/data_sources.json"))
  
  # get queries from queries database
  haml :index
end

# /d new data source, :name edit, type, parameters
get '/d/?:did?' do
  
end  

# /q new query, :qid edit, data source name, description, query text
get '/q/?:qid?' do
  # if :qid, get the info from the queries database
  # otherwise initialize @dsname, @desc, @txt
  
end  

# /e/:qid execute query return data (CSV, JSON)
get '/e/:qid' do
  
end  


__END__

@@ index
%html
  %h2 welcome to quirkv
  %h3 data sources
  - @data_sources.each do |e|
    %a{:href => "d/#{e["name"]}"}= e["name"]
  
