var express = require('express');
var router = express.Router();

let index = require('../controllers/index'); 
let bulksendgrid = require('../controllers/bulksendgrid')

/* GET home page. */
router.get('/', index.index);

/* POST home page */
router.post('/', bulksendgrid.send)
module.exports = router;
