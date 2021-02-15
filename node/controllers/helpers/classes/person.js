/**
 * Dependencies
 */
const uppercaseWordsString = require('../helpers/uppercaseFirstLetterWordString');

/**
 * Person Class
 */
class Person {

  /**
   * Constructor 
   */
  constructor(firstName, lastName, email){
    this.firstName = uppercaseWordsString(firstName);
    this.lastName = uppercaseWordsString(lastName);
    this.name = firstName + " " + lastName;

    // validate email format
    if(this.isValidEmail(email)){
      this.email = email;
    }    
  }

  /**
   * Check email's format is valid
   */
  isValidEmail(email){
    // expecting a string
    if(typeof email !== 'string'){
      throw new Error('Expecting a string as an email');
    }

    // check email's format
    if (/^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/.test(email))
      return (true);

    return false;
  }
}

// Export class 
module.exports = {
  Person: Person
};