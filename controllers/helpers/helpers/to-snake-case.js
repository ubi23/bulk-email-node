// copied from https://github.com/sendgrid/sendgrid-nodejs/blob/b2a7be0bd10ad3de154b4160a65e6c9f9b745094/packages/helpers/helpers/to-snake-case.js

/**
 * Dependencies
 */
const convertKeys = require('./convert-keys');
const strToSnakeCase = require('./str-to-snake-case');

/**
 * Convert object keys to snake case
 */
module.exports = function toSnakeCase(obj, ignored) {
  return convertKeys(obj, strToSnakeCase, ignored);
};