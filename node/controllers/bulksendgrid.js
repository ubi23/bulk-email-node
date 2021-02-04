// import parseCSV file
let parseCSV = require('./parseCSV.controllers');
let person = require('./person');
let Person = person.Person


exports.send = function(req, res) {
  
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
  console.log(req.file, "----------\n");
  console.log(req.body, "-----------\n");
  console.log(req.files);
  let csvRows = parseCSV.processCSVFile(req, res);
  
  console.log("bulksendgrid -> ",csvRows);
  //TODO for loop to retrieve recipients email and store that into the array
  //let recipients = retrieveRecipients(csvRows)

  //sendgridController.sendEmail(recipients, data)

  res.redirect('/');

  
  return 0;
}

/* 
  return array with recipient's emails
*/
function retrieveRecipients(csvRows){
  //TODO

}

/*let p = new Person("Ubaid", "Khan", "u.khan@equalsmoney.com");
  console.log("from email ", fromEmail);
  console.log("from name ", fromName);
  console.log("template id", templateID);
  console.log("filename: ", filename);
  console.log("subject: ", subject);
  console.log("category: ", category);
  console.log("Separate senders: ", isSeparatedSenders);
  console.log("Her name's " + p.name + " and email's " + p.email);
  console.log("data templateID: ", data.templateID);*/