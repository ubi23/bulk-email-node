const fs = require('fs');
const csv = require('fast-csv');


exports.processCSVFile =  async function(req, res) {
  return new Promise((resolve, reject) =>  {
    const fileRows = [];
    csv.parseFile(req.file.path, {trim: true, headers:true})
    .on("data", function(row){
      fileRows.push(row); 
    })
    .on("end", function(){ 
      var saveFile = req.body.saveFile;
      if(saveFile == 0) // if user decided to not save the file
        fs.unlinkSync(req.file.path); // remove temp file
      
      resolve(fileRows); // promise's done
    })
    .on("error", error => reject(error));  
  })
  .catch(err => {throw  err});
}

