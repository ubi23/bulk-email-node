/**
 * Dependencies
 */
//const { send } = require('@sendgrid/mail');
const sgMail = require('@sendgrid/mail');
const Message = require('./helpers/classes/message');

// set the API Key from environment variables
sgMail.setApiKey(process.env.SENDGRID_API_KEY);
// set the wrappers for substitution 
sgMail.setSubstitutionWrappers('--', '--'); // may have to change if dynamic template is provided

/**
 * Send emails through the SendGrid API
 */
module.exports.sendBulkEmails = (data, recipients) => {
  
  // Expecting either an array or a Map as recipients
  if (!Array.isArray(recipients) && (recipients instanceof Map !== true) || recipients === null ){
    throw new Error('Expecting either an array or a Map as recipients');
  }

  // check if different senders
  if (data.isSeparateSenders === true){
    
    recipients.forEach((dealerData, dealerEmail) => {
      // Change the from value to be the dealer's name and email rather than what was provided in the form
      data.from = { email: dealerEmail, name: dealerData.dealerName};
      data.recipients = dealerData.recipients;
      const msg = new Message(data);
      
      sendEmails(msg.toJSON());
    });

  } else {

    // same sender for all emails
    data.recipients = recipients;
    const msg = new Message(data);
    
    sendEmails(msg.toJSON());
  } 
}

/**
 * 
 */
function sendEmails(msg){
  // send emails
  sgMail
  .sendMultiple(msg) 
  .then(() => {
    // emails sent without any error
    console.log('Successsssss');
  })
  .catch(error => {
    // Log friendly error
    console.error(error);

    if (error.response) {
      // Extract error msg
      const {message, code, response} = error;

      // Extract response msg
      const {headers, body} = response;

      console.error(body);
    }
  });
}