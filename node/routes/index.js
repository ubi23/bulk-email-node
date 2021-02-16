var express = require('express');
var router = express.Router();
const multer = require('multer');
const index = require('../controllers/index'); 
const bulksendgrid = require('../controllers/bulksendgrid');
const formValidator = require('../controllers/helpers/helpers/validate-form');
console.log('formValidator -> ' ,formValidator);


// destination where the file will be uploaded temporarily
const upload = multer({ dest: 'tmp/csv/' });


/* GET home page. */
router.get('/', index.index);

/* Send all emails */
router.post('/', upload.single('filename'), formValidator.validate(), bulksendgrid.send);


module.exports = router;