const fs = require('fs');
const csv = require('fast-csv');
//  let person = require('./person');
//let Person = person.Person



exports.processCSVFile = function(req, res) {
  const fileRows = [];
  csv.parseFile(req.file.path, {trim: true})
  .on("data", function(data){
    fileRows.push(data); // push each row
  })
  .on("end", function(){
    console.log(fileRows); // contains array of arrays
    //fs.unlinkSync(req.file.path); // remove temp file
    return fileRows;
  });
  return fileRows;
}
