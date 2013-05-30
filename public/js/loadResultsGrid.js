function loadResultsGrid(qid) {
  var xmlHttp = null;
  xmlHttp = new XMLHttpRequest();
  xmlHttp.open( "GET", "/e/" + qid, false );
  xmlHttp.send( null );
    
  var rows = JSON.parse(xmlHttp.responseText.replace(/\\/g, ""));
  var cols = [];
  var data = [];

  var options = {
    enableCellNavigation: true,
    enableColumnReorder: false
  };

  // generating dumb column names
  for (c = 0; c < rows[0].length; c++) {
    s  = "{\"id\":\"c" + (c + 1) + "\",\"name\":\"\",\"field\":\"c" + (c + 1) + "\"}";
    cols.push(JSON.parse(s));
  };

  // wiring up rows to columns for slickgrid
  for (r = 0; r < rows.length; r++) {
    d = "{"
    for (c = 0; c < cols.length; c++) {
      d = d + "\"" + cols[c]["field"] + "\":\"" + rows[r][c] + "\",";
    };
    d = d.slice(0, -1) + "}";

    data.push(JSON.parse(d));
    //data.push(d);
  };

  var grid = new Slick.Grid("#slickGrid", data, cols, options);
  return qid; 
};
