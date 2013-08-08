require 'coffee-script'

# ---

command = require './command.coffee'

# ---

###
	* @param {string} path
	* @param {string} name
	* @param {function(?err)} callback
###
exports.import = (path, name, callback) ->
	command.exec 'import', path, '--vsys', '0', '--vmname', name, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot import #{path} into #{name}" if code > 0		
		return do callback if callback
		
###
	* @param {string} name
	* @param {string} path
	* @param {function(?err)} callback
###
exports.export = (name, path, callback) ->
	command.exec 'export', name, '--output', path, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot export #{name} into #{path}" if code > 0		
		return do callback if callback
		
###
	* @param {string} from
	* @param {string} to
	* @param {function(?err)} callback
###
exports.clone = (from, to, callback) ->
	command.exec 'clonevm', from, '--name', to, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot clone #{from} into #{to}" if code > 0		
		return do callback if callback
		