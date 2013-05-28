#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'stringio'
require 'haml'
require 'json'
require 'sqlite3'
require 'securerandom'

helpers do
  def data_sources()
    JSON.parse(IO.read("config/data_sources.json"))
  end

  def query_database(dsname)
    ds = data_sources.first{|e| e["name"] == dsname}
    case ds["type"]
      when "sqllite"
        db = SQLite3::Database.open "#{ds["parameters"]["location"]}"
      when "mssql"
        # do something else...
      else
        # fix your config file?
      end

    db
  end

  def get_query(qid)
    q = "select * from queries where qid = '#{qid}';"
    query_database('queries').execute(q)
  end

  def save_query(qid, dsname, desc, qtext)
    # for now, a heavy-handed kind of upsert
    s =  "insert or replace into queries values ( "
    s << "'#{qid}', '#{dsname}', '#{desc}', '#{qtext}' ); "

    results = query_database('queries').execute(s)

    qid
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
get '/d/?:name?' do
  if params[:name] then
    @data_source =  data_sources.select{|e| e["name"] == params[:name]}[0]
  else
    @data_source = {"name"=> "", "type"=> "", "parameters" => {}}
  end
  
  haml :dform
end  

post '/dsave' do
  # NOTE: brittle code here, you can really muck up your config file
  # or crash the app if you aren't careful with what goes into the form inputs

  # get all the data sources
  # if #{params[:name]} exists, pop it out and we'll replace it
  nd = data_sources.delete_if{|e| e["name"] == params[:name]}

  # otherwise, just append this one to the list
  n = {
    "name" => params[:name],
    "type" => params[:type],
    "parameters" => eval(params[:parameters])
    }

  nd << n

  File.open("config/data_sources.json", "w"){|f| f.write(JSON.pretty_generate(nd))}
  redirect to('/')
end

# /q new query, :qid edit, data source name, description, query text
get '/q/?:qid?' do
  # if :qid, get the info from the queries database
  # otherwise initialize @dsname, @desc, @txt
  q = nil
  if params[:qid] then
    # should only get one query record back with the following 
    gq = get_query("#{params[:qid]}")
    if (gq.length == 1) then
      q = gq[0]
    end
  end

  # [qid, dsname, desc, qtext]
  @query = q || [nil,nil,nil,nil]

  haml :qform
end  

post '/qsave' do
  # NOTE: maybe we should be able to run the query
  # before we save it to the database..

  qid = params[:qid].empty? ? SecureRandom.hex(3) : params[:qid]

  r = save_query(qid, params[:dsname], params[:desc], params[:qtext])
  
  redirect to("/q/#{qid}")
end

# /e/:qid/p[1]..p[n] execute query return data (JSON array default)
get '/e/:q*' do
  qid, *a = params[:captures]

  p = a[0].split("/")

  gq = get_query(qid)[0]
  
  ds = gq[1]
  q = eval("\"" + gq[3] + "\"")
  
  @results = query_database(ds).execute(q)
  
  @results.to_s
end  

__END__

@@ index
%html
  %h2 welcome to quirkv
  %h3 data sources
  %a{:href => "d"}= "new data source"
  %br
  %br
  - @data_sources.each do |e|
    %a{:href => "d/#{e["name"]}"}= e["name"]
    %br
  %h3 queries
  %a{:href => "q"}= "new query"
  %br
  %br
  - @queries.each do |e|
    %a{:href => "q/#{e[0]}"}= e[2]
    %br
 
@@ dform
%html
  %head
    :javascript
      function toggleNameReadOnly() {
        var dsname = document.getElementById("dsname");
        if (dsname.value.length > 0) {
          dsname.readOnly=true;    
        }; 
      };
  %body{:onload => "toggleNameReadOnly()"}
    %h2 add or edit a data source
    %form#dform{:action => "/dsave", :method => "post"}
      %fieldset
        %ul
          %li
            %label{:for => "name"} name:
            %input{:id => "dsname", :type => "text", :name => "name", :class => "text", :value => @data_source["name"]}
          %li
            %label{:for => "type"} type:
            %input{:type => "text", :name => "type", :class => "text", :value => @data_source["type"]}
          %li
            %label{:for => "parameters"} parameters:
            %textarea{:name => "parameters"}= @data_source["parameters"].to_s
        %input{:type => "submit", :value => "save", :class => "button"}
    
@@ qform
%html
  %h2 add or edit a query 
  %form#qform{:action => "/qsave", :method => "post"}
    %fieldset
      %input{:type =>"hidden", :name => :qid, :value => @query[0]}
      %ol
        %li
          %label{:for => "dsname"} data source name:
          %input{:type => "text", :name => "dsname", :class => "text", :value => @query[1]}
        %li
          %label{:for => "desc"} description:
          %input{:type => "text", :name => "desc", :class => "text", :value => @query[2]}
        %li
          %label{:for => "qtext"} query text:
          %textarea{:name => "qtext"}= @query[3]
      %input{:type => "submit", :value => "save", :class => "button"}
  %a{:href => "/e/#{@query[0]}", :style => "visibility:#{@query[0] ? "visible" : "hidden" };" } run query
