parse = require './parse.coffee'
command = require './command.coffee'

###
	* List vms.
	*
	* @param {function(?err, result)} callback
###
exports.list = (callback) ->
	command.exec 'list', 'vms', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot list vms" if code > 0
		return callback null, parse.namepair_list(output) if callback

###
	* Show vm info.
	*
	* @param {string} vm
	* @param {function(?err, info)} callback
###
exports.info = (vm, callback) ->
	command.exec 'showvminfo', vm, '--machinereadable', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot show vm info for #{vm}" if code > 0
		return callback null, parse.machinereadable_list(output) if callback

###
	* Enumerate guest properties
	*
	* @param {string} vm
	* @param {function(?err, result)} callback
###
exports.properties = (vm, callback) ->
	command.exec 'guestproperty', 'enumerate', vm, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot enumerate properties for #{vm}" if code > 0
		return callback null, parse.property_list(output) if callback

###
	* Imports vm.
	*
	* @param {string} path
	* @param {string} vm
	* @param {function(?err)} callback
###
exports.import = (path, vm, callback) ->
	command.exec 'import', path, '--vsys', '0', '--vmname', vm, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot import #{path} into #{vm}" if code > 0		
		return do callback if callback

###
	* Exports vm.
	*
	* @param {string} vm
	* @param {string} path
	* @param {function(?err)} callback
###
exports.export = (vm, path, callback) ->
	command.exec 'export', vm, '--output', path, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot export #{vm} into #{path}" if code > 0		
		return do callback if callback

###
	* Clones vm. The vm is automatically registered.
	*
	* @param {string} from
	* @param {string} to
	* @param {function(?err)} callback
###
exports.clone = (from, to, callback) ->
	command.exec 'clonevm', from, '--name', to, '--register', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot clone #{from} into #{to}" if code > 0		
		return do callback if callback

###
	* Removes vm. The vm files are deleted.
	*
	* @param {string} vm
	* @param {function(?err)} callback
###
exports.remove = (vm, callback) ->
	command.exec 'unregistervm', vm, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot remove #{vm}" if code > 0		
		return do callback if callback
