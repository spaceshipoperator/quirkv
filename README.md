quirkv
======

save a query, hit a URL to run your query and get your data, edit your query...maybe some parameters

to do:
- establish a couple connections to databases (sqllite, pgsql, mssql, odbc, etc)
- / index, present user with "new connection, query" and list connections, queries
- /d new data source, :name edit, type, parameters
- /q new query, :qid edit, data source name, description, text
- /e/:qid execute query return data (CSV, JSON)

codemirror text area, submit/post save query to server, uniquely name, accessible via URL
