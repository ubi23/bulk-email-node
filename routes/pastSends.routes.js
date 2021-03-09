module.exports = app => {
  const pastSends = require('../controllers/pastSends.controller.js');

  const router = require('express').Router();

  // Create a new Transactions
  router.post('/', pastSends.create);

  // Retrieve all Transactionss
  router.get('/', pastSends.findAll);

  // Retrieve a single Transactions with id
  router.get('/:id', pastSends.findOne);

  app.use('/logs', router);
};