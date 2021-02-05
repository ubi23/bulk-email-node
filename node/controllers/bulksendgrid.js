// import parseCSV file
let parseCSV = require('./parseCSV.controllers');
let person = require('./person');
let Person = person.Person


exports.send = async function(req, res) {
  
  var fromEmail = req.body.fromEmail;
  var fromName = req.body.fromName;
  var templateID = req.body.templateID;
  var filename = req.body.filename;
  var subject = req.body.subject;
  var category = req.body.category;
  var isSeparatedSenders = req.body.isSeparate; 
  var data = {
    fromEmail: fromEmail,
    fromName: fromName,
    templateID: templateID,
    filename: filename,
    subject: subject,
    category: category,
    isSeparatedSenders: isSeparatedSenders
  };
  
  try {
    const csvRows = await parseCSV.processCSVFile(req, res);
    let recipients = retrieveRecipients(csvRows); //[Person1, Person2, ..., PersonN ]
    sendgridController.sendEmail(recipients, data)
  } catch(error) {
    console.error(error);
    // TODO possibly send a error response message
  }
  
  res.redirect('/');
  return 0;
}


/* 
  return array with recipient's emails
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

