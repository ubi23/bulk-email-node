/**
 * Dependencies
 */
const parseCSV = require('./helpers/helpers/parse-csv');
const sendgridController = require('./sendgrid.controllers');
const handleValidationResult = require('./helpers/helpers/validate-form');
const retrieveRecipients = require('./helpers/helpers/retrieve-recipients')

/**
 * 
 */
module.exports = async function(req, res) {
  
  // Results from form validation
  const { isInternalServerError, hasValidationFailed, errors } = handleValidationResult(req); 
  
  // Check if anyone tried to manipulate the form maliciously
  if (true === isInternalServerError){
    return res.sendStatus(500);
  }

  // Form data is either incomplete or not valid
  if (true === hasValidationFailed){
    return res.render('index', { formData: req.body, errors: errors});
  } 

  // Form validation was successful 
  // Getting values from the form inputs
  var data = {
    from : { 
      email: req.body.fromEmail, 
      name: req.body.fromName
    },
    replyTo: req.body.replyTo,
    templateId : req.body.templateID,
    subject : req.body.subject,
    category : req.body.category,
    isSeparateSenders : req.body.isSeparate 
  };
  
  try {
    // Retrieve rows from CSV file -> [row1, ..., rowN]
    const csvRows = await parseCSV(req, res); 
  
    // Retrieve recipients from the csv rows, returns [Person1, Person2, ..., PersonN ] or Dealers Map if separate senders 
    const recipients = retrieveRecipients(csvRows, data.isSeparateSenders); 

    // Send emails
    sendgridController.sendBulkEmails(data, recipients); 
    
    return res.render('index', {success: 'Emails sent successfully!', }); 
  } catch(error) {

    console.error(error);
    return res.render('index', {success: 'An error occurred while processing the data!', }); // may want to change the key to a proper name rather than success
  }
}