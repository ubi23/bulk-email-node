/**
 * Dependencies
 */
const {body, validationResult} = require('express-validator');
const getTemplate = require('./get-template');


// here check if file uploaded or not
const validate = () => {
  
  // if true, fields with falsy values (eg "", 0, false, null) will also not exist
  var existsOptions = {checkFalsy: true}; 

  return [
    body('fromEmail')
      .exists().bail()
      .isEmail().withMessage('Please insert a valid email address.').bail()
      .normalizeEmail(), 

    body('replyTo')
      .exists().bail()
      .isEmail().withMessage('Please insert a valid email address.').bail()
      .normalizeEmail(), 

    body('saveFile')
      .exists(existsOptions).bail()
      .escape().trim().isBoolean().withMessage('Please specify this field.'),

    body('isCsvFile', 'Please upload a CSV file').exists().bail()
      .escape().trim().isBoolean().toBoolean()
      .custom(value => isCsvFile(value)).bail(), 

    body('fromName', 'Please insert your correct name')
      .exists(existsOptions).bail()
      .escape().trim().isAlpha('en-GB', {ignore: " "}).withMessage('Please do no insert digits in your name.').bail()
      .notEmpty(),

    body('templateId', 'Please insert a correct template ID')
      .exists(existsOptions).bail()
      .escape().trim().custom(templateID => checkTemplateIDFormatValidity(templateID)).bail()
      .isLength({min: 34, max:36}).bail()
      .custom(templateID => getTemplate(templateID)).withMessage('The template ID provided does not exist or it is not active, please check your Sendgrid account.').bail(),

    body('subject', 'subject not specified')
      .optional().isString().escape().trim(),

    body('isSeparate', 'is separate')
      .exists().bail()
      .escape().trim().isBoolean().bail()
      .toBoolean({strict:true}), 

    // TODO
    body('category', 'category is not specified').exists(), //TODO check if it's in acceptable option's values
  ];
}

/**
 * Check that the template id consists only of digits, letters and '-' and does not 
 * start and end with a '-' or does not contain more than one consecutive '-'
 */
function checkTemplateIDFormatValidity(str){

  if (typeof str !== 'string'){
    throw new Error('Expecting string');
  }

  let matches = str.match(/(\w+\-{1})+\w+/g);
  if (matches !== null && matches[0] === str){
      return true;
  }

  return false;
}

/**
 * 
 */
function isCsvFile(isCsvFile){

  if (typeof isCsvFile !== 'boolean'){
    throw new Error('Expecting a boolean as type of isCsvFile');
  }

  return isCsvFile;
}

/**
 * Check if errors occurred during form validation
 * and return validation status accordingly 
 */
module.exports = (req) => {

  try {

    const validationStatus = {
      isInternalServerError: false,
      hasValidationFailed: false,
    }
    const errors = validationResult(req);
    
    if(!errors.isEmpty()){
      
      const errorsArray = errors.array();
      validationStatus.hasValidationFailed = true;
      
      // Check if anyone tried to manipulate the form and send 
      // back an Internal Server Error
      errorsArray.forEach((error) => {
        if (error.value === undefined) {
          validationStatus.isInternalServerError = true;
          return validationStatus;
        }
      });

      validationStatus.errors = errorsArray;
    }  

    return validationStatus;

  } catch (err) {
    console.error("error from try and catch during form validation", err);
  }
}

module.exports.validate = validate;