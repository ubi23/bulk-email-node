// import sendgrid API
//const sgMail = require('@sendgrid/mail');


module.exports.sendEmail = (recipients, data) => {
  const sgMail = require('@sendgrid/mail');
  sgMail.setApiKey(process.env.SENDGRID_API_KEY);
  sgMail.setSubstitutionWrappers('--', '--');

  /*recipients.forEach(element => {
    console.log("show sth",element);
  });*/
  const msg = {
    personalizations: [
      {
        "to": [
          {
            "email": recipients[0].email,
            "name": recipients[0].name
          }
        ],
        "subject": "Example 01",
        "substitutions": {
          "firstName": "John"
        }
      },
      {
        "to": [
          {
            "email": recipients[1].email,
            "name": "Jane"
          }
        ],
        "subject": "Example 02",
        "substitutions": {
          "firstName": "Jane"
        }
      },
      {
        "to": [
          {
            "email": recipients[2].email,
            "name": "Matt"
          }
        ],
        "subject": "Example 03",
        "substitutions": {
          "firstName": "Matt"
        }
      }
    ],
    from: {email: data.fromEmail, name: data.fromName}, 
    reply_to: {email: 'business@equalsmoney.com', name: 'Equals Money'},
    subject: data.subject,
    template_id: data.templateID,
    //substitutions:  {"firstName": 'UbaidTest3'},
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