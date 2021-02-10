// import sendgrid API
const sgMail = require('@sendgrid/mail');
sgMail.setApiKey(process.env.SENDGRID_API_KEY);


module.exports.sendEmail = (recipients, data) => {
  
  const msg = {
    to: ['khanubaid97.uk@gmail.com'], // recipients
    from: {'email': data.fromEmail, 'name': data.fromName}, 
    reply_to: {'email': 'business@equalsmoney.com', 'name': 'Equals Money'},
    subject: data.subject,
    templateID: data.templateID,
    categories: [data.category],
    html: ''
  };

  
  //ES8
  (async () => {
    try {
      await sgMail.send(msg);
    } catch (error) {
      console.error(error);

      if (error.response) {
        console.error(error.response.body)
      }
    }
  })();
}