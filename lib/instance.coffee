require 'coffee-script'

# ---

command = require './command.coffee'

# ---

###
	* @param {string} name
	* @param {boolean=} headless
	* @param {function(?err, ?headless, callback)}
###
exports.start = (name, headless=true, callback) ->
	command.exec 'startvm', name, headless ? '--headless' : null, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot start #{name}" if code > 0
		return do callback if callback
		
###
	* @param {string} name
	* @param {function(?err)}
###
exports.stop = (name, callback) ->
	command.exec 'controlvm', 'poweroff', name, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot stop #{name}" if code > 0
		return do callback if callback
		
###
	* @param {string} name
	* @param {function(?err)}
###
exports.pause = (name, callback) ->
	command.exec 'controlvm', 'pause', name, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot pause #{name}" if code > 0
		return do callback if callback
		
###
	* @param {string} name
	* @param {function(?err)}
###
exports.resume = (name, callback) ->
	command.exec 'controlvm', 'resume', name, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot resume #{name}" if code > 0
		return do callback if callback