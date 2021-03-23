 const uppercaseWordsString = require('./uppercase-first-letter-word-string');

test('uppercaseWordsString function throws an error as non string passed as argument', () => {

  expect(() => uppercaseWordsString(undefined)).toThrow('String expected for conversion');
  expect(() => uppercaseWordsString(null)).toThrow('String expected for conversion');
  expect(() => uppercaseWordsString(122)).toThrow('String expected for conversion');
  expect(() => uppercaseWordsString(true)).toThrow('String expected for conversion');
  expect(() => uppercaseWordsString(false)).toThrow('String expected for conversion');
  expect(() => uppercaseWordsString({})).toThrow('String expected for conversion');
});

test('uppercaseWordsString function gets only numbers passed in a string', () => {
  expect(uppercaseWordsString('1113223 323')).toBe('1113223 323');
});

test('uppercaseWordsString function receives only spaces in a string', () => {
  expect(uppercaseWordsString('           ')).toBe('');
});

test('uppercaseWordsString function removes extra spaces between words in a string', () => {
  // here given more than one space between numbers
  expect(uppercaseWordsString('1113223    323')).toBe('1113223 323');
  // here spaces at beginning and end
  expect(uppercaseWordsString('   1113223 323   ')).toBe('1113223 323');
  // here spaces at beginning 
  expect(uppercaseWordsString('   1113223 323')).toBe('1113223 323');
  // here spaces at end 
  expect(uppercaseWordsString('1113223 323      ')).toBe('1113223 323');
});

test('uppercaseWordsString function works correctly with multiple case words in a string', () => {
  expect(uppercaseWordsString('TEST')).toBe('Test');
  expect(uppercaseWordsString('test')).toBe('Test');
  expect(uppercaseWordsString('Test')).toBe('Test');
  expect(uppercaseWordsString('tEST')).toBe('Test');
  expect(uppercaseWordsString('TeSt')).toBe('Test');
  expect(uppercaseWordsString('TEST ONE')).toBe('Test One');
  expect(uppercaseWordsString('test one')).toBe('Test One');
  expect(uppercaseWordsString('test one 1')).toBe('Test One 1');
});