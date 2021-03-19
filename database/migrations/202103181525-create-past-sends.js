'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('PastSends', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      userId: {
        type: Sequelize.STRING(256),
      },
      fromEmail: {
        allowNull: false,
        type: Sequelize.STRING(256)
      },
      fromName: {
        type: Sequelize.STRING(256)
      },
      templateId: {
        allowNull: false,
        type: Sequelize.STRING(256)
      },
      subject: {
        type: Sequelize.STRING(256)
      },
      filename: {
        type: Sequelize.STRING(256)
      },
      status: {
        type: Sequelize.BOOLEAN
      },
      emailType: {
        type: Sequelize.BOOLEAN
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      }
    });
  },
  down: async (queryInterface, Sequelize) => {
    await queryInterface.dropTable('PastSends');
  }
};