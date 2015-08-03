var http = require('http'),
    path = require('path');


var server = http.createServer(function(request, response){
  response.writeHead(200, { 'Content-Type': 'application/json' });

  var app = {};
  app.trackName = "foo";
  app.formattedPrice = "CHF 10.0";

  var appResult = {};
  appResult.results = [];
  appResult.results.push(app);

  response.write(JSON.stringify(appResult));
  response.end();

}).listen(4444);
