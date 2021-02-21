/**
 * Dependencies
 */
const fs = require('fs');
const csv = require('fast-csv');

/**
 * 
 */
module.exports =  async function(req, res) {
  return new Promise((resolve, reject) =>  {
    const fileRows = [];
    csv.parseFile(req.file.path, {trim: true, headers:true})
    .on("data", function(row){
      fileRows.push(row); 
    })
    .on("end", function(){ 
      let saveFile = req.body.saveFile;
      if(saveFile == 0) // if user decided to not save the file
        fs.unlinkSync(req.file.path); // remove temp file
      
      resolve(fileRows); // promise's done
    })
    .on("error", error => reject(error));  
  })
  .catch(err => console.log('parsing eeeerrror -> ', err)); // here cannot open path file as file not provided, return this as error and stop execution
}