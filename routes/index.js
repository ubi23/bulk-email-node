const express = require('express');
const router = express.Router();
const multer = require('multer');
const index = require('../controllers/index'); 
const bulkEmail = require('../controllers/bulk-email.controller');
const formValidator = require('../controllers/helpers/helpers/validate-form');
const pastSends = require('../controllers/pastSends.controller.js');

// destination where the file will be uploaded temporarily
const upload = multer({ dest: 'tmp/csv/' });

/* GET home page. */
router.get('/', index.index);

/* Send all emails */
router.post('/', upload.single('filename'), formValidator.validate(), bulkEmail, pastSends.create);


module.exports = router;