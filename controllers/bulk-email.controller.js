/**
 * Dependencies
 */
const parseCSV = require('./helpers/helpers/parse-csv');
const sendgridController = require('./sendgrid.controllers');
const handleValidationResult = require('./helpers/helpers/validate-form');
const person = require('./helpers/classes/person');
const Person = person.Person
const toCamelCase = require('./helpers/helpers/to-camel-case');

/**
 * 
 */
module.exports = async function(req, res) {
  
  // Results from form validation
  const { isInternalServerError, hasValidationFailed, errors } = handleValidationResult(req); 
  
  // Check if anyone tried to manipulate the form maliciously
  if (isInternalServerError === true){
    return res.sendStatus(500);
  }

  // Form data is either incomplete or not valid
  if (hasValidationFailed === true){
    return res.render('index', { formData: req.body, errors: errors});
  } 

  // Form validation was successful 
  // Getting values from the form inputs
  var data = {
    from : { 
      email: req.body.fromEmail, 
      name: req.body.fromName
    },
    templateId : req.body.templateID,
    subject : req.body.subject,
    category : req.body.category,
    isSeparateSenders : req.body.isSeparate 
  };
  
  try {
    // Retrieve rows from CSV file -> [row1, ..., rowN]
    const csvRows = await parseCSV(req, res); 

    // Retrieve recipients from the csv rows [Person1, Person2, ..., PersonN ] or Dealers Map if separate senders 
    const recipients = retrieveRecipients(csvRows, data.isSeparateSenders); 

    // Send emails
    sendgridController.sendBulkEmails(data, recipients); 
    
    res.render('index', {success: 'oh I sent few emails', });
    return 0;
  } catch(error) {
    console.error(error);
    res.render('index', {success: 'An error occurred while processing the data!', }); // may want to change the key to a proper name rather than success
    return 1;
  }
}

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

  
  // return recipients = [Person1, .., PersonN]
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
   *    dealerEmail3: {
   *      dealerName: '',
   *      recipients: [person1, ..., personN]
   *    }
   * }
   * 
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