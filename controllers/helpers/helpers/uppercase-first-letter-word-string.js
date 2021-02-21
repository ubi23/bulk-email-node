/**
 * Make the first letter of each word in a string uppercase 
 * and lowercase the rest. 
 */
module.exports = function uppercaseWordsString(str){

    // expecting a string
    if(typeof str !== 'string'){
        throw new Error('String expected for conversion');
    }
    
    // split string into words
    const words = str.trim().split(' ');

    // make first letter uppercase, rest lowercase
    for(let i = 0; i<words.length; i++){
        words[i] = words[i][0].toUpperCase() + words[i].substr(1).toLowerCase();
    }
    
    return words.join(' ');
}