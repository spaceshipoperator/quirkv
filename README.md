quirkv - teh database destroyer
======

don't take this too seriously.  Also, for your own safety and the safety of others, do not run this
silly little web application on a server that is accessible by just anybody else.  Feel free to run
it on your local host and ponder the possibilities of making it available to others.  Should you feel
so moved, you might consider what it would take to make this thing a bit more robust, resilient to sql
injection would be a good place to start.  Meanwhile, take it for what it's worth:

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
- [X] save query to queries database, uniquely name, accessible via URL
- [X] add new data source/query links to index page
- [X] allow for queries to include parameters that can be provided in the URL (/e/:qid/:p1/:pN)
- add codemirror text area to add/edit query form
- better UI stuff, dropdown list for data source types, CSS-love on the forms 
- (rake) task to create queries.db && create table queries (qid not null primary key, dsname, desc, qtext)
- establish a connections to different database flavors(sqllite, mssql, pgsql, odbc, etc)
- visualizations (nvd3, d3, high charts...), simple configurations wrapping one or more saved queries (following conventions)
- export/import from/to ethercalc
- query tagging
- users, logins, query permissions, sharing, etc
- allow for collaborative editing
- ember-table maybe