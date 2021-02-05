const fs = require('fs');
const csv = require('fast-csv');
let person = require('./person');
const { rejects } = require('assert');
const { resolve } = require('path');
let Person = person.Person



exports.processCSVFile =  async function(req, res) {
  return new Promise((resolve, reject) =>  {
    const fileRows = [];
    csv.parseFile(req.file.path, {trim: true, headers:true})
    .on("data", function(data){
      fileRows.push(data); // push each row
    })
    .on("end", function(){  
      fs.unlinkSync(req.file.path); // remove temp file
      resolve(fileRows); // promise's done
    })
    .on("error", error => reject(error));  
  })
  .catch(err => {throw  err});
}

/*let recipients = [];
    fileRows.forEach(unsub_person => {
      let firsName = unsub_person.first_name;
      let lastName = unsub_person.last_name;
      let email = unsub_person.email;
      var person1 = new Person(firsName, lastName, email);
      recipients.push(person1);
    });

    console.log("recipients ", recipients);*/