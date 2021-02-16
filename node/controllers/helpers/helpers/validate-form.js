/**
 * Dependencies
 */
const {body, validationResult} = require('express-validator');

// here check the case when I do exports.validate = () => {} and module.exports = ()=> {}

const validate = () => {
  var existsOptions = {checkFalsy: true}; // if true, fields with falsy values (eg "", 0, false, null) will also not exist

  return [
    body('fromEmail')
      .exists().bail()
      .isEmail().withMessage('Please insert a valid email address.').bail()
      .normalizeEmail(), 

    body('saveFile')
      .exists(existsOptions).bail()
      .escape().trim().isBoolean().withMessage('Please specify this field.'),

    // TODO
    //body('filename', 'no file uploaded').exists(), // TODO

    body('fromName', 'Please insert your correct name')
      .exists(existsOptions).bail()
      .escape().trim().isAlpha('en-GB', {ignore: " "}).withMessage('Please do no insert digits in your name.').bail()
      .notEmpty(),

    body('templateID', 'Please insert a correct template ID')
      .exists(existsOptions).bail()
      .escape().trim().custom((str) => checkTemplateIDValidity(str)).bail()
      .isLength({min: 36, max:36}), 

    body('subject', 'subject not specified')
      .optional().isString().escape().trim(),

    body('isSeparate', 'is separate')
      .exists().bail()
      .escape().trim().isBoolean(), 

    // TODO
    body('category', 'category is not specified').exists(), //TODO check if is in acceptable values range
  ];
}


function checkTemplateIDValidity(str){
  if (typeof str !== 'string' || typeof str === undefined){
    throw new Error('Expecting string');
  }

  let matches = str.match(/(\w+\-{1})+\w+/g);
  if (matches !== null && matches[0] === str){
      return true;
  }
  return false;
}


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
    console.log("error from try and catch", err);
  }
}

module.exports.validate = validate;