// import parseCSV file
let parseCSV = require('./parseCSV.controllers');
let sendgridController = require('./sendgrid.controllers');
let person = require('./person');
let Person = person.Person



exports.send = async function(req, res) {
  
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
    const csvRows = await parseCSV.processCSVFile(req, res);
    let recipients = retrieveRecipients(csvRows); //[Person1, Person2, ..., PersonN ]
    console.log(recipients);
    //sendgridController.sendEmail(recipients, data)
  } catch(error) {
    console.error(error);
  }
  
  res.redirect('/');
  return 0;
}


/* 
  return array with recipient's people -> [Person1, ..., PersonN]
*/
function retrieveRecipients(csvRows){
  let recipients = [];
  csvRows.forEach(unsub_person => {
    console.log(unsub_person);
    let firsName = unsub_person.first_name;
    let lastName = unsub_person.last_name;
    let email = unsub_person.email;
    var person1 = new Person(firsName, lastName, email);
    recipients.push(person1);
  });
  return recipients;
}

