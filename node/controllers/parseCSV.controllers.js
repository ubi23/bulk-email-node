const fs = require('fs');
const csv = require('fast-csv');


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

