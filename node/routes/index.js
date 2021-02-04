var express = require('express');
var router = express.Router();
const multer = require('multer');
let index = require('../controllers/index'); 
let bulksendgrid = require('../controllers/bulksendgrid');


// destination where the file will be uploaded temporarily
const upload = multer({ dest: 'tmp/csv/' });


/* GET home page. */
router.get('/', index.index);

/* Send all emails */
router.post('/', upload.single('filename'), bulksendgrid.send);


module.exports = router;
