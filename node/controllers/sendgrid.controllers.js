/**
 * Dependencies
 */
const sgMail = require('@sendgrid/mail');

// set the API Key from environment variables
sgMail.setApiKey(process.env.SENDGRID_API_KEY);

// set the wrappers for substitution 
sgMail.setSubstitutionWrappers('--', '--');


/**
 * Send emails through the SendGrid API
 */
module.exports.sendEmail = (recipients, data) => {
  
  // contains substitutions for each recipient
  const personalizations = createPersonalization(recipients);
  
  // message object to be passed to the API
  const msg = {
    personalizations: personalizations,
    from: {email: data.fromEmail, name: data.fromName}, 
    reply_to: {email: 'business@equalsmoney.com', name: 'Equals Money'},
    subject: data.subject,
    template_id: data.templateID,
    categories: [data.category],
    html: 'Make sure this is never empty, otherwise you will get an error'
  };

  
  sgMail
  .sendMultiple(msg)
  .then(() => {
    // Celebrate
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


function createPersonalization(recipients){
  if(typeof recipients === undefined || typeof recipients === 'string'){
    return;
  }

  let personalizations = [];
  recipients.forEach((recipient) => { 
    personalizations.push(
      {
        'to': [recipient],
        'substitutions': {'firstName': recipient.firstName}
      }
    );
  });
  return personalizations;
}