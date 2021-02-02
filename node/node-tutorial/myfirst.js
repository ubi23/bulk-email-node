//  a module is a set of functions as in a library.
// you include a module with require
var http = require('http'); 
var dt = require('./myfirstmodule');

// now have access to the HTTP module and application is able
// to create a server

// create a server object
http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/html'}); // write a response to the client
  res.write("The date and time are currently " + dt.myDateTime())
  res.end('Hello World'); // end the response
}).listen(8080);// the server object listens on port 8080

//the function passed into http.createServer() method will be executed when someone 
// tries to access the computer on port 8080  


