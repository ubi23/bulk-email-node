const {
    Model
} = require('sequelize');

module.exports = (sequelize, DataTypes) => {
    class History extends Model { };

    History.init({
        id: {
            type: DataTypes.INTEGER,
            autoIncrement: true,
            primaryKey: true
        },
        userId: {
            type: DataTypes.STRING(256)
        },
        fromEmail: {
            type: DataTypes.STRING(256),
            allowNull: false
        },
        fromName: {
            type: DataTypes.STRING(256)
        },
        templateId: {
            type: DataTypes.STRING(256),
            allowNull: false
        },
        subject: {
            type: DataTypes.TEXT
        },
        filename: {
            type: DataTypes.STRING(256)
        },
        status: {
            type: DataTypes.BOOLEAN 
        },
    }, {
        sequelize, 
        modelName: 'History',
    });

    return History;
};