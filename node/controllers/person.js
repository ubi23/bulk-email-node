class Person {
  constructor(first_name, last_name, email){
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