const express = require('express');
const router = express.Router();
const multer = require('multer');
const index = require('../controllers/index'); 
const bulkEmail = require('../controllers/bulk-email.controller');
const formValidator = require('../controllers/helpers/helpers/validate-form');
const pastSends = require('../controllers/pastSends.controller.js');

const upload = multer({ 
  // destination where the file will be uploaded temporarily
  dest: 'tmp/csv/', 

  // filter function to accept only CSV files
  fileFilter: function(req, file, cb){
    
    if (file.mimetype !== 'text/csv'){
      req.body.isCsvFile = false;
      return cb(null, false); 
    }

    req.body.isCsvFile = true;
    return cb(null, true);
  } 
});

function handleFileUpload(req, res, next){
  // check if any file provided at all
  if (undefined === req.file){
    req.body.isCsvFile = false;
  } 

  next()
}

/* GET home page. */
router.get('/', index.index);

/* Send all emails */
router.post('/', upload.single('filename'), handleFileUpload, formValidator.validate(), bulkEmail, pastSends.create);

module.exports = router;