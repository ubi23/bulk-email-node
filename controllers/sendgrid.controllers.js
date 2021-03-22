/**
 * Dependencies
 */
const sgMail = require('@sendgrid/mail');
const Message = require('./helpers/classes/message');
const SendgridInternalError = require('./helpers/errors/sendgrid-error');
require('dotenv').config()

// set the API Key from environment variables
sgMail.setApiKey(process.env.SENDGRID_API_KEY);
// set the wrappers for substitution 
sgMail.setSubstitutionWrappers('--', '--'); // may have to change if dynamic template is provided

// maximum number of recipients for each Sendgrid API call
const SENDGRID_MAX_RECIPIENTS = Number(process.env.SENDGRID_MAX_RECIPIENTS);

/**
 * Send emails through the SendGrid API
 */
module.exports.sendBulkEmails = async (data, recipients) => {
  
  // Expecting either an array or a Map as recipients
  if (!Array.isArray(recipients) && (recipients instanceof Map !== true) || recipients === null ){
    throw new Error('Expecting either an array or a Map as recipients');
  }

  // check if different senders
  if (data.isSeparateSenders === true){
    const promises = [];
    recipients.forEach((dealerData, dealerEmail) => {
      // Change the from value to be the dealer's name and email rather than what was provided in the form
      data.from = { email: dealerEmail, name: dealerData.dealerName};
      data.replyTo = dealerEmail;
      let dealerRecipients = dealerData.recipients;

      if (dealerRecipients.length <= SENDGRID_MAX_RECIPIENTS){
        promises.push(send(dealerRecipients, data));
      } else {
        promises.push(sendInChunks(dealerRecipients, data));        
      }
    });
    return Promise.all(promises);
  } else {
    // same sender for all emails

    // checking if recipients are 1000 or less as
    // per Sendgrid API, you can send to a maximum of 1000
    // recipients for each API call
    if (recipients.length <= SENDGRID_MAX_RECIPIENTS) {
      return send(recipients, data);
    } else {
      return sendInChunks(recipients, data);
    } 
  } 
}

/**
 * 
 */
async function sendEmails(msg) {
  // send emails
  return sgMail
  .sendMultiple(msg) 
  .then(() => {
    // emails sent without any error
    console.log('Successsssss');
  })
  .catch(error => {
    // Log friendly error
    console.error('error occurred in sendgrid -> ',error);

    if (error.response) {
      // Extract error msg
      const {message, code, response} = error;

      // Extract response msg
      const {headers, body} = response;

      console.error(body);
    }

    throw new SendgridInternalError('An error inside sendgrid occurred');
  });
}

/**
 * Send emails in chunks, 1000 recipients per each Sendgrid API call
 */
async function sendInChunks(recipients, data){
  let promises = [];
  for (let i = 0; i < recipients.length; i+= SENDGRID_MAX_RECIPIENTS){
    let chunkedRecipients = recipients.slice(i, i+ SENDGRID_MAX_RECIPIENTS);
    const promise = send(chunkedRecipients, data);
    promises.push(promise);
  }
  return Promise.all(promises);
}

/**
 * This sends emails given an array of recipients and a data object
 */
async function send(recipients, data){
  data.recipients = recipients;
  const msg = new Message(data);
  return sendEmails(msg.toJSON());
}
