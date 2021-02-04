const fs = require('fs');
const csv = require('fast-csv');
let person = require('./person');
let Person = person.Person



exports.processCSVFile = function(req, res) {
  const fileRows = [];
  csv.parseFile(req.file.path, {trim: true, headers:true})
  .on("data", function(data){
    fileRows.push(data); // push each row
  })
  .on("end", function(){
    //console.log(fileRows); // contains array of arrays
    let recipients = [];
    fileRows.forEach(unsub_person => {
      let firsName = unsub_person.first_name;
      let lastName = unsub_person.last_name;
      let email = unsub_person.email;
      var person1 = new Person(firsName, lastName, email);
      recipients.push(person1);
    });
    console.log("recipients ", recipients);
    fs.unlinkSync(req.file.path); // remove temp file
  });
  
}
