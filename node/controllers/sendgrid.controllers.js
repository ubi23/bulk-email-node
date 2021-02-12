const sgMail = require('@sendgrid/mail');
sgMail.setApiKey(process.env.SENDGRID_API_KEY);
sgMail.setSubstitutionWrappers('--', '--');


module.exports.sendEmail = (recipients, data) => {
  
  // TODO
  const personalizations = createPersonalization(recipients);
  
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
        'substitutions': {'firstName': recipient.name}
      }
    );
  });
  return personalizations;
}