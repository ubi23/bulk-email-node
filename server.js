const express = require('express');
const bodyParser = require('body-parser');
const indexRouter = require('./routes/index')
const path = require('path');
const db = require('./models');
// instance of express app
const app = express(); 

const start = async () => {
  
  // parse requests of content-type - application/json
  app.use(bodyParser.json());
  
  // parse requests of content-type - application/x-www-form-urlencoded
  app.use(bodyParser.urlencoded({ extended: true }));

  // view engine setup
  app.set('views', path.join(__dirname, 'views'));
  app.set('view engine', 'jade');

  // use this middleware for all requests
  app.use('/', indexRouter);
   
  // set port, listen for requests
  const PORT = process.env.PORT || 3000;

  app.listen(PORT, () => console.log(`Server is running on port ${PORT}.`));

  process.on('exit', function () {
    sequelize.connectionManager.close().then(() => console.log('Shut down gracefully'));
  });
};

(async () => await start())();