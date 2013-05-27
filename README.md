quirkv
======

a rudimentary query editor(hardly), runner, browser...itch-scratching toy

save a query, hit a URL to run your query and get your data, edit your query...maybe some parameters

``ruby quirkv.rb``

then in your browser at http://localhost:4567

- /
  index, present user with "new connection, query" and list connections, queries
  
- /d[/:name]
  new data source, :name edit, type, parameters
  
- /q[/:qid]
  new query, :qid edit, data source name, description, text
  
- /e/:qid
  execute query return data (CSV, JSON)

to do:
- save query to queries database, uniquely name, accessible via URL
- add new data source/query links to index page
- add codemirror text area to add/edit query form
- establish a connections to different database flavors(sqllite, mssql, pgsql, odbc, etc)
- allow for queries to include parameters that can be provided in the URL (/e/:qid/:p1/:pN)
- better UI stuff, dropdown list for data source types, CSS-love on the forms 
- visualizations (nvd3, d3, high charts...)
- query tagging
- users, logins, query permissions, etc
- allow for collaborative editing
- ember-table maybe