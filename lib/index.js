require('coffee-script');

// ---

var fs = require('fs');
var path = require('path');

// ---

fs.readdirSync(__dirname).forEach(function(file) {
	var match = file.match(/^(.+?)\.coffee$/);
	
	if (!match) {
		return;
	}
	
	exports[match[1]] = require(path.join(__dirname, file));
});
