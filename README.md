quirkv
======

save a query, hit a URL to run your query and get your data in CSV, edit your query...maybe some parameters

to do:
- establish a couple connections to databases (MSSQL, pg, etc)
- / index, present user with "new query" link
- /n new query, choose connection, short description, codemirror text area, submit/post save query to server, uniquely name, accessible via URL
- /e/:qid retreive query (qid) for edit
- /r/:qid run the query return CSV
