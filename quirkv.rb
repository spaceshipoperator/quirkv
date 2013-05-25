#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'stringio'
require 'haml'
require 'json'
require 'sqlite3'

helpers do
  def data_sources()
    JSON.parse(IO.read("config/data_sources.json"))
  end

  def get_query(qid)
    q = "select * from queries where qid = '#{qid}';"
    qdb = data_sources.first{|e| e["name"] == "queries"}
    case qdb["type"]
      when "sqllite"
        db = SQLite3::Database.open "#{qdb["parameters"]["location"]}"
        results = db.execute(q)
      when "mssql"
        # do something else...
      else
        # fix your config file?
      end
    results
  end
  
end

# / index, present user with "new data source, query" and list data sources, queries
get '/' do
  # get data sources from config file
  @data_sources = data_sources

  # get queries from queries database
  # http://stackoverflow.com/questions/3551746/calling-sinatra-from-within-sinatra
  @queries = eval(self.call(
    'REQUEST_METHOD' => 'GET',
    'PATH_INFO' => '/e/YVk4I7U',
    'rack.input' => StringIO.new
  )[2].join(''))

  haml :index
end

# /d new data source, :name edit, type, parameters
get '/d/?:did?' do
  
  haml :dform
end  

post '/dsave' do
  puts 'saved teh data source, yay'
  redirect back
end

# /q new query, :qid edit, data source name, description, query text
get '/q/?:qid?' do
  # if :qid, get the info from the queries database
  # otherwise initialize @dsname, @desc, @txt
  
  haml :qform
end  

post '/qsave' do
  puts 'yay, saved teh query'
  redirect back
end

# /e/:qid execute query return data (CSV, JSON)
get '/e/:qid' do
  @results = get_query("#{params[:qid]}").to_s
  # execute_query(q)
  # connect to the queries database, get the dsname and qtext given the qid
  # run the query, deliver the results
  @results
end  

__END__

@@ index
%html
  %h2 welcome to quirkv
  %h3 data sources
  - @data_sources.each do |e|
    %a{:href => "d/#{e["name"]}"}= e["name"]
  %h3 queries
  - @queries.each do |e|
    %a{:href => "q/#{e[0]}"}= e[2]
 
@@ dform
%html
  %h2 add or edit a data source
  %form#dform{:action => "/dsave", :method => "post"}
    %fieldset
      %ol
        %li
          %label{:for => "name"} name:
          %input{:type => "text", :name => "name", :class => "text"}
        %li
          %label{:for => "type"} type:
          %input{:type => "text", :name => "type", :class => "text"}
        %li
          %label{:for => "parameters"} parameters:
          %textarea{:name => "parameters"}
      %input{:type => "submit", :value => "save", :class => "button"}
    
 
@@ qform
%html
  %h2 add or edit a query form
  %form#qform{:action => "/qsave", :method => "post"}
    %fieldset
      %ol
        %li
          %label{:for => "dsname"} data source name:
          %input{:type => "text", :name => "dsname", :class => "text"}
        %li
          %label{:for => "desc"} description:
          %input{:type => "text", :name => "desc", :class => "text"}
        %li
          %label{:for => "qtext"} query text:
          %textarea{:name => "qtext"}
      %input{:type => "submit", :value => "save", :class => "button"}
