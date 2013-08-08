require('coffee-script');

// ---

['command', 'instance', 'list', 'machine', 'parse', 'show'].forEach(function (module) {
	exports[module] = require('./' + module + '.coffee');
});
