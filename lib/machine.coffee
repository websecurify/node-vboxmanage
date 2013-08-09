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
	* @param {string} name
	* @param {function(?err, info)} callback
###
exports.info = (name, callback) ->
	command.exec 'showvminfo', name, '--machinereadable', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot show vm info for #{name}" if code > 0
		return callback null, parse.machinereadable_list(output) if callback

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
	* Clones vm.
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
