/**
 * Dependencies
 */
const deepClone = require('../helpers/deep-clone');
const toSnakeCase = require('../helpers/to-snake-case')

/**
 * class Message
 */
class Message {

  /**
   * Constructor
   */
  constructor(data){

    // Initialize properties
    this.isDynamic = false;
    this.personalizations = [];
    this.html = 'Make sure this is never empty, otherwise you will get an error';
    this.replyTo = { email: 'business@equalsmoney.com', name: 'Equals Money'}; // this is hard coded, may retrieve these values from env?


    if (data) {
      this.fromData(data);
    }
  }

  /**
   * 
   */
  fromData(data){
    
    // Expecting an object
    if (typeof data !== 'object') {
      throw new Error('Expecting an object for Message data');
    }

    // making a deep copy to prevent changes to the original objects
    data = deepClone(data); // try to remove this


    const {
      from, subject, templateId, category, // categories instead of category?
      recipients
    } = data;

    // Set data
    this.setFrom(from);
    this.setSubject(subject);
    this.setTemplateId(templateId);
    this.setCategory(category); // need to implement this according to specs setCategories?
    this.setRecipients(recipients);

    this.createPersonalizations();
  }

  /**
   * 
   */
  createPersonalizations(){

    if (!this.hasOwnProperty('recipients')){
      throw new Error('The current object class does not have the \'recipients\' property');
    }
  
    this.recipients
      .forEach(recipient => this.addPersonalization(recipient));
  }

  /**
   * add personalization
   */
  addPersonalization(recipient){

    let personalization = { 'to': [recipient]};

    // check if dynamic and pass the according substitution key name
    if (this.isDynamic){
      personalization['dynamic_template_data'] = recipient; // here more work needed when enabling this feature
    } else {
      personalization['substitutions'] = recipient;
    }

    this.personalizations.push(personalization);
  }

  /**
   * this still needs to be implemented properly according to the type of data that will be passed from the form
   */
  setCategory(category){

    /*if(typeof category === 'string'){
      if (category.length < 1){
        throw new Error('If category exists, then its value should be at least sth');
      }
      this.categories = [category];
    } */
    this.categories = ['not specified'];
  }

  /**
   * 
   */
  setFrom(from){

    if (typeof from !== 'object' || from === null){
      throw new Error('Expecting an object as from type');
    }

    if (typeof from.email !== 'string'){
      throw new Error('The email field of the from object is required');
    }

    this.from = from;
  }

  /**
   * 
   */
  setRecipients(recipients){

    // Expecting an array
    if(!Array.isArray(recipients) || recipients === null){
      throw new Error('Expecting an array as recipients to personalization');
    }

    // Minimum number of recipients is 1, and maximum is 1000
    if ( 1 <= recipients.length <= 1000){
      this.recipients = recipients;
    } else {
      throw new Error('Expecting at least 1 recipient and no more than 1000');
    }
  }

  

  /**
   * 
   */
  setSubject(subject){

    if (typeof subject !== 'string'){ // may need to check that, it needs to be at least 1 char? yes it does
      throw new Error('Expecting a string as subject');
    }

    if (!(subject.length < 1)){
      this.subject = subject;
    } 
  }

  /**
   * 
   */
  setTemplateId(templateId){

    if (typeof templateId !== 'string'){
      throw new Error('Message class is expecting a string as templateId');
    }

    if (templateId.indexOf('d-') === 0){
      this.isDynamic = true;
    }

    this.templateId = templateId;
  }

  /**
   * return the Message class as a JSON object
   */
  toJSON(){
    
    const {
      from, replyTo, subject, templateId,
      personalizations, categories, html
    } = this;

    const json = {
      html, replyTo, personalizations 
    };

    // check other properties exist
    if (typeof from !== 'undefined'){
      json.from = from;
    }
    if (typeof subject !== 'undefined'){
      json.subject = subject;
    }
    if (typeof templateId !== 'undefined'){
      json.templateId = templateId;
    }
    if (typeof categories !== 'undefined'){
      json.categories = categories;
    }

    json.sendAt = 1613778240;

    return toSnakeCase(json, []); // here 'substitutions' needs to go in
  }
}

//Export class
module.exports = Message;