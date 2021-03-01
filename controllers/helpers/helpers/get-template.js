/**
 * Dependencies 
 */
const client = require('@sendgrid/client');
client.setApiKey(process.env.SENDGRID_API_KEY);

/**
 *  
 */
async function getTemplate(templateID){
  return new Promise((resolve, reject) => {

    if (typeof templateID !== 'string') {
      throw new Error('Expecting a string as template id');
    }

    const request = {
      method: 'GET',
      url: '/v3/templates/' + templateID
    };

    client.request(request)
      .then(([response, ]) => {
        let recentVersion = response.body.versions[0];
        let isTemplateActive = recentVersion.active;

        resolve(response.statusCode === 200 && isTemplateActive === 1); 
      })
      .catch(err => {
        console.error('error occured here -> ', err);
        reject(false);
      });   
  });
}

module.exports = getTemplate;