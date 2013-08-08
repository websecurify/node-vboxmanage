require 'coffee-script'

# ---

parse= require './parse.coffee'
command = require './command.coffee'

# ---

###
	* @param {string} name
	* @param {function(?err, result)} callback
###
exports.vm_info = (name, callback) ->
	command.exec 'showvminfo', name, '--machinereadable', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot show info for #{name}" if code > 0
		return callback null, parse.machinereadable_list(output) if callback
		