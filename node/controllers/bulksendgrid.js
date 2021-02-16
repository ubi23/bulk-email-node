const parseCSV = require('./parseCSV.controllers');
const sendgridController = require('./sendgrid.controllers');
const handleValidationResult = require('./helpers/helpers/validate-form');
const person = require('./helpers/classes/person');
const Person = person.Person




exports.send = async function(req, res) {
  
  const { isInternalServerError, hasValidationFailed, errors } = handleValidationResult(req); 
  if (isInternalServerError === true){
    return res.sendStatus(500);
  }
  if (hasValidationFailed === true){
    return res.render('index', { formData: req.body, errors: errors});
  } 

  // success
  res.render('index', {success: 'oh I sent few emails', });
  return;
  var data = {
    fromEmail : req.body.fromEmail,
    fromName : req.body.fromName,
    templateID : req.body.templateID,
    filename : req.body.filename,
    subject : req.body.subject,
    category : req.body.category,
    isSeparatedSenders : req.body.isSeparate
  };
  
  try {
    let csvRows = await parseCSV.processCSVFile(req, res); // retrieve rows in CSV file [row1, ..., rowN]
    let recipients = retrieveRecipients(csvRows); //[Person1, Person2, ..., PersonN ]
    sendgridController.sendEmail(recipients, data); // send emails
  } catch(error) {
    console.error(error);
  }

  
  res.redirect('/');
  return 0;
}


/**
 * return array with recipient's -> [Person1, ..., PersonN]
 */
function retrieveRecipients(csvRows){
  let recipients = [];
  csvRows.forEach(unsub_person => {
    let firsName = unsub_person.first_name;
    let lastName = unsub_person.last_name;
    let email = unsub_person.email;
    var person1 = new Person(firsName, lastName, email);
    recipients.push(person1);
  });
  return recipients;
}