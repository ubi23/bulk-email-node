const uppercaseWordsString = require('./helpers/uppercaseFirstLetterWordString');

class Person {
  constructor(first_name, last_name, email){
    this.firstName = uppercaseWordsString(first_name);
    this.lastName = uppercaseWordsString(last_name);
    this.name = first_name + " " + last_name;

    if(this.isValidEmail(email)){
      this.email = email;
    }    
  }

  isValidEmail(email){
    if (/^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/.test(email))
      return (true);

    return false;
  }
}

module.exports = {
  Person: Person
}