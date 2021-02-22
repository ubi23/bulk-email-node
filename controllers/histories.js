const db = require('../models');
const History = db.History;

// create a new history
exports.create = (req, res) => {

    History
        .create(req.body, {})
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            res.status(500).send({
                message: 
                    err.message || "Some error occurred while creating a log"
            });
        });
    
};

// retrieve all orders from the db
exports.findAll = (req, res) => {
    const userId = req.query.userId;
    var condition = userId ? { userId: userId } : null;

    History
        .findAll({
            where: condition,  
        })
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            res.status(500).send({
                message: 
                    err.message || "Some error occurred while retrieving past logs"
            });
        });
};

// find a single log with an id
exports.findAll = (req, res) => {
    const id = req.params.id;


    History
        .findByPk(id, {})
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            res.status(500).send({
                message: 
                    err.message || "Some error occurred while retrieving past logs"
            });
        });
};