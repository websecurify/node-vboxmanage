var path = require('path');

// ---

[
	'api',
	'logger',
].forEach(function (module) {
	exports[module] = require(path.join(__dirname, module + '.js'));
});
