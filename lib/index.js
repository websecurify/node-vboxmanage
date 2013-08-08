require('coffee-script')

// ---

['command', 'instance', 'list', 'logger', 'machine', 'parse', 'show'].forEach(function (module) {
	exports[module] = require('./' + module + '.coffee');
});
