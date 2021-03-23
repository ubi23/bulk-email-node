const {toCamelCase, toSnakeCase} = require('./str-change-case');

let objWithKeys = {};

beforeAll(() => {
  objWithKeys = {
    'key 1 with space': 1,
    ' Second keySpaced': 2,
    'Third_key': 3,
    '      fourth _key    ': 4,
    'Key_____five': 5
  };
});

test('object\'s keys convert to camel case', () => {
  
  let expectedObj = {
    'key1WithSpace': 1,
    'secondKeySpaced': 2,
    'thirdKey': 3,
    'fourthKey': 4,
    'keyFive': 5
  };

  expect(toCamelCase(objWithKeys)).toEqual(expectedObj);
});

test('toCamelCase function throws error as non object passed for conversion', () => {
  let str = '';

  expect(() => toCamelCase(str)).toThrow();
  expect(() => toCamelCase(str)).toThrow(Error);
  expect(() => toCamelCase(str)).toThrow('Non object passed to convertKeys: ' + str);
  expect(() => toCamelCase(undefined)).toThrow('Non object passed to convertKeys: ' + undefined);
  expect(() => toCamelCase(null)).toThrow('Non object passed to convertKeys: ' + null);
  expect(() => toCamelCase(true)).toThrow('Non object passed to convertKeys: ' + true);
  expect(() => toCamelCase(false)).toThrow('Non object passed to convertKeys: ' + false);
  expect(() => toCamelCase(1)).toThrow('Non object passed to convertKeys: ' + 1);
});

test('object\'s keys convert to snake case', () => {
  
  let expectedObj = {
    'key1_with_space': 1,
    'second_key_spaced': 2,
    'third_key': 3,
    'fourth_key': 4,
    'key_five': 5
  };
  expect(toSnakeCase(objWithKeys)).toEqual(expectedObj);
});

test('toSnakeCase function throws error as non object passed for conversion', () => {
  let str = '';

  expect(() => toSnakeCase(str)).toThrow();
  expect(() => toSnakeCase(str)).toThrow(Error);
  expect(() => toSnakeCase(str)).toThrow('Non object passed to convertKeys: ' + str);
  expect(() => toSnakeCase(undefined)).toThrow('Non object passed to convertKeys: ' + undefined);
  expect(() => toSnakeCase(null)).toThrow('Non object passed to convertKeys: ' + null);
  expect(() => toSnakeCase(true)).toThrow('Non object passed to convertKeys: ' + true);
  expect(() => toSnakeCase(false)).toThrow('Non object passed to convertKeys: ' + false);
  expect(() => toSnakeCase(1)).toThrow('Non object passed to convertKeys: ' + 1);
});