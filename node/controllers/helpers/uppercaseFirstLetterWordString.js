module.exports = function uppercaseWordsString(str){
    if(typeof str !== 'string' || typeof str === undefined){
        throw new Error('String expected for conversion');
    }
    
    const words = str.split(' ');
    for(let i = 0; i<words.length; i++){
        words[i] = words[i][0].toUpperCase() + words[i].substr(1).toLowerCase();
    }

    return words.join(' ');
}


