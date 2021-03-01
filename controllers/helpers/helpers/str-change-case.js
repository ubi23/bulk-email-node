// this is copied from https://github.com/sendgrid/sendgrid-nodejs/blob/b2a7be0bd10ad3de154b4160a65e6c9f9b745094/packages/helpers/helpers/str-to-camel-case.js

/**
 * Dependencies
 */
const convertKeys = require('./convert-keys');

function strToCamelCase(str) {
  if (typeof str !== 'string') {
    throw new Error('String expected for conversion to snake case');
  }
  return str
    .trim()
    .replace(/_+|\-+/g, ' ')
    .replace(/(?:^\w|[A-Z]|\b\w|\s+)/g, function(match, index) {
      if (Number(match) === 0) {
        return '';
      }
      return (index === 0) ? match.toLowerCase() : match.toUpperCase();
    });
};

function strToSnakeCase(str) {
  if (typeof str !== 'string') {
    throw new Error('String expected for conversion to snake case');
  }
  return str.trim().replace(/(\s*\-*\b\w|[A-Z])/g, function($1) {
    $1 = $1.trim().toLowerCase().replace('-', '');
    return ($1[0] === '_' ? '' : '_') + $1;
  }).slice(1);
};

module.exports.toCamelCase = function toCamelCase(obj, ignored) {
  return convertKeys(obj, strToCamelCase, ignored);
};

module.exports.toSnakeCase = function toSnakeCase(obj, ignored) {
  return convertKeys(obj, strToSnakeCase, ignored);
};