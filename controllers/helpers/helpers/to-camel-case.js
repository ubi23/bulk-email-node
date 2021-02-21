// this is copied from https://github.com/sendgrid/sendgrid-nodejs/blob/b2a7be0bd10ad3de154b4160a65e6c9f9b745094/packages/helpers/helpers/to-camel-case.js

/**
 * Dependencies
 */
const convertKeys = require('./convert-keys');
const strToCamelCase = require('./str-to-camel-case');

/**
 * Convert object keys to camel case
 */
module.exports = function toCamelCase(obj, ignored) {
  return convertKeys(obj, strToCamelCase, ignored);
};