const db = require('../models');
const PastSend = db.PastSend;

// create a new history
exports.create = (req, res) => {

  PastSend
    .create(req.body, {})
    .then(data => {
      console.log('created this data = ', data);
    })
    .catch(err => {
      console.log('error occurred while creating a log ', err);
      /*res.status(500).send({
        message: err.message || "Some error occurred while creating a log"
      });*/
    });
};

// retrieve all orders from the db
exports.findAll = (req, res) => {
  const userId = req.query.userId;
  var condition = userId ? { userId: userId } : null;

  PastSend
    .findAll({
      where: condition,  
    })
    .then(data => {
      //res.send(data);
      return res.render('logs', { data: data});
    })
    .catch(err => {
      res.status(500).send({
        message: err.message || "Some error occurred while retrieving past logs"
      });
    });
};

// find a single log with an id
exports.findOne = (req, res) => {
  const id = req.params.id;

  PastSend
    .findByPk(id, {})
    .then(data => {
      res.send(data);
    })
    .catch(err => {
      res.status(500).send({
        message: err.message || "Some error occurred while retrieving past logs"
      });
    });
};