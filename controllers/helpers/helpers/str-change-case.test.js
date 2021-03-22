const {toCamelCase, toSnakeCase} = require('./str-change-case');

test('string with spaces converts to camel case', () => {
  const objWithKeyContainingSpaces = {
    'key 1 with space': 1,
    ' Second keySpaced': 2,
    'Third_key': 3,
    '      fourth _key    ': 4,
    'Key_____five': 5
  };
  const expectedObj = {
    'key1WithSpace': 1,
    'secondKeySpaced': 2,
    'thirdKey': 3,
    'fourthKey': 4,
    'keyFive': 5
  };
  expect(toCamelCase(objWithKeyContainingSpaces)).toEqual(expectedObj);
});