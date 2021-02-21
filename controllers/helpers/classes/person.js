/**
 * Dependencies
 */
const uppercaseWordsString = require('../helpers/uppercase-first-letter-word-string');

/**
 * Person Class
 */
class Person {

  /**
   * Constructor 
   */
  constructor(firstName, lastName, email, subOne, subTwo){
    
    this.setFirstName(firstName);
    this.setLastName(lastName);
    this.setName();
    this.setSubs(subOne, subTwo);
    
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

  /**
   * 
   */
  setFirstName(firstName){

    // Expecting string
    if(typeof firstName !== 'string' || firstName.length < 1){
      throw new Error('Expecting a string as first name for person');
    }

    this.firstName = uppercaseWordsString(firstName);
  }

  /**
   * 
   */
  setLastName(lastName){

    // Expecting string
    if(typeof lastName !== 'string' || lastName.length < 1){
      throw new Error('Expecting a string as first name for person');
    }

    this.lastName = uppercaseWordsString(lastName);
  }

  /**
   * 
   */
  setName(){

    // Check if firstName and lastName are set  
    if(this.hasOwnProperty('firstName') === true && this.hasOwnProperty('lastName') === true){
      this.name = this.firstName + ' ' + this.lastName;
    } else {
      throw new Error('Either first name or last name or both are missing to create a valid name');
    }    
  }

  /**
   * 
   */
  setSubs(subOne, subTwo){

    // Expecting string
    if(typeof subOne !== 'string'){
      throw new Error('Expecting a string as sub one for person');
    } else {
      this.subOne = uppercaseWordsString(subOne);
    }

    if(typeof subTwo !== 'string'){
      throw new Error('Expecting a string as sub two for person');
    } else {
      this.subTwo = uppercaseWordsString(subTwo);
    }
  }

}

// Export class 
module.exports = {
  Person: Person
};