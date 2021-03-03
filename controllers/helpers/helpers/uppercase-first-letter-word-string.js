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

    // remove extra spaces between words
    const wordsWithoutSpaces = words.filter((word, index) =>  word !== '');

    // make first letter uppercase, rest lowercase
    for(let i = 0; i < wordsWithoutSpaces.length; i++){
        wordsWithoutSpaces[i] = wordsWithoutSpaces[i][0].toUpperCase() + wordsWithoutSpaces[i].substr(1).toLowerCase();
    }
    
    return wordsWithoutSpaces.join(' ');
}

//console.log(module.exports('RebeCca &'));