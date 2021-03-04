const express = require('express');
const bodyParser = require('body-parser');
const indexRouter = require('./routes/index')
const path = require('path');
const exphbs = require('express-handlebars');
// instance of express app
const app = express(); 

const start = async () => {
  
  app.use(express.static(__dirname + '/public'));

  // parse requests of content-type - application/json
  app.use(bodyParser.json());
  
  // parse requests of content-type - application/x-www-form-urlencoded
  app.use(bodyParser.urlencoded({ extended: true }));
  
  // view engine setup
  app.set('view engine', 'hbs');
  app.engine('hbs', exphbs({
    extname: 'hbs',
    defaultLayout: 'index',
    layoutsDir: __dirname + '/views/layouts/',
    partialsDir: __dirname + '/views/partials/',

    helpers: {
      ifEq: function(key, param, options){
        console.log('options = ', options);
        console.log('param = ', param);
        console.log('key = ', key);
        if(param == key){
          //console.log('value is  = ', value);
          return true;
        }
      }
    }
  }));

  // use this middleware for all requests
  app.use('/', indexRouter);
   
  // set port, listen for requests
  const PORT = process.env.PORT || 3000;

  app.listen(PORT, () => console.log(`Server is running on port ${PORT}.`));
};

(async () => await start())();