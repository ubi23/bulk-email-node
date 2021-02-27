/**
 * Dependencies
 */
const person = require('../classes/person');
const Person = person.Person
const toCamelCase = require('./to-camel-case');

/**
 * return array with recipient's -> [Person1, ..., PersonN] or a Map if separate senders
 */
function retrieveRecipients(csvRows, isSeparateSenders){

  if(!Array.isArray(csvRows) || csvRows === null) {
    throw new Error('Expecting an array as rows of the csv file');
  }

  if(typeof isSeparateSenders !== 'boolean' || isSeparateSenders == null){
    throw new Error('Expecting a boolean as separate senders value'); 
  }

  if (!isSeparateSenders) { 
    let recipients = [];
    
    csvRows.forEach(unsubPerson => {
    
      // making the object's key camel case, such that anything can be provided
      // in the csv headers and we don't have to use "_" to reference the 
      // keys in the JS code
      unsubPerson = toCamelCase(unsubPerson, []);

      recipients.push(createRecipientPerson(unsubPerson))
    });

    return recipients;
  }

  /*
  * dealers = 
  * {
  *    dealerEmail1: {
  *      dealerName: '',
  *      recipients: [person1, ..., personN]
  *    },
  *    dealerEmail2: {
  *      dealerName: '',
  *      recipients: [person1, ..., personN]
  *    },
  * }
  */
  let dealers = new Map(); 

  csvRows.forEach(unsubPerson => {
  
    unsubPerson = toCamelCase(unsubPerson, []);

    let recipient  = createRecipientPerson(unsubPerson);
    let dealerEmail = unsubPerson.dealerEmail;

    if (typeof dealerEmail !== 'string'){
        throw new Error('Expecting a string as dealer email from csv file');
    }

    if (dealers.has(dealerEmail) === true){
      dealers.get(dealerEmail).recipients.push(recipient);
    } else {
      dealers.set(dealerEmail, {
        dealerName: unsubPerson.dealerName,
        recipients: [recipient]
      });
    }
  });
  return dealers;
}

/**
 * 
 */
function createRecipientPerson(unsubPerson) {
  let firstName = unsubPerson.firstName;
  let lastName = unsubPerson.lastName;
  let email = unsubPerson.email;
  let subOne = unsubPerson.subOne;
  let subTwo = unsubPerson.subTwo;
  let person = new Person(firstName, lastName, email, subOne, subTwo);

  return person;
}

module.exports = retrieveRecipients;