parse= require './parse.coffee'
command = require './command.coffee'

# ---

###
	* @param {string} name
	* @param {function(?err, result)} callback
###
exports.enumerate = (name, callback) ->
	command.exec 'guestproperty', 'enumerate', name, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot enumerate properties for #{name}" if code > 0
		return callback null, parse.property_list(output) if callback
		