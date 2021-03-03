/**
 * Dependencies
 */
//const { send } = require('@sendgrid/mail');
const sgMail = require('@sendgrid/mail');
const Message = require('./helpers/classes/message');
require('dotenv').config()

// set the API Key from environment variables
sgMail.setApiKey(process.env.SENDGRID_API_KEY);
// set the wrappers for substitution 
sgMail.setSubstitutionWrappers('--', '--'); // may have to change if dynamic template is provided

const SENDGRID_MAX_RECIPIENTS = Number(process.env.SENDGRID_MAX_RECIPIENTS);
console.log('SENDGRID_MAX_RECIPIENTS = ', SENDGRID_MAX_RECIPIENTS);
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
      let dealerRecipients = dealerData.recipients;

      if (dealerRecipients.length <= SENDGRID_MAX_RECIPIENTS){
        send(dealerRecipients, data);
      } else {
        sendInChunks(dealerRecipients, data);        
      }  

    });
  } else {
    // same sender for all emails

    // checking if recipients are 1000 or less as
    // per Sendgrid API, you can send to a maximum of 1000
    // recipients for each API call
    if (recipients.length <= SENDGRID_MAX_RECIPIENTS) {
      send(recipients, data);
    } else {
      sendInChunks(recipients, data);
    } 
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


/**
 * Send emails in chunks, 1000 recipients per each Sendgrid API call
 */
function sendInChunks(recipients, data){
  for (let i = 0; i < recipients.length; i+= SENDGRID_MAX_RECIPIENTS){
    let chunkedRecipients = recipients.slice(i, i+ SENDGRID_MAX_RECIPIENTS);
    send(chunkedRecipients, data);
  }
}

/**
 * This sends emails given an array of recipients and a data object
 */
function send(recipients, data){
  data.recipients = recipients;
  const msg = new Message(data);
  sendEmails(msg.toJSON());
}