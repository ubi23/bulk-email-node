/**
 * Dependencies
 */
const client = require('@sendgrid/client');
client.setApiKey(process.env.SENDGRID_API_KEY);

/**
 * Returns the template subject given a valid templateId
 */
module.exports = async (templateId) => {
  
  if (typeof templateId !== 'string') {
    throw new Error('Expecting a string as template id');
  }

  const request = {
    method: 'GET',
    url: '/v3/templates/' + templateId
  };

  return client.request(request)
    .then(([response, ]) => {
      let recentVersion = response.body.versions[0];
      
      console.log(recentVersion.subject);
      return recentVersion.subject; 
    })
    .catch(err => {
      console.error('error occured here -> ', err);
      return undefined;
    });   
}