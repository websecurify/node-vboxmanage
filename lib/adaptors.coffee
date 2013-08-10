machine = require './machine.coffee'
command = require './command.coffee'

###
	* Lists adaptors.
	*
	* @param {string} vm
	* @param {function(?err, result)} callback
###
exports.list = (vm, callback) ->
	machine.properties vm, (err, result) ->
		return callback err if err
		
		adaptors = {}
		
		for key, val of result
			match = key.match /^\/VirtualBox\/GuestInfo\/Net\/(\d+)\/(.+?)$/
			
			continue if not match
			
			index = parseInt(match[1]) + 1
			path = match[2]
			oref = ref = adaptors["Adaptor #{index}"] ?= {}
			
			for key in path.split('/')
				path = key
				oref = ref
				ref = ref[path] ?= {}
				
			oref[path] = val.value
			
		callback null, adaptors if callback

###
	* Sets hostonly network adaptor on vm.
	*
	* @param {string} vm
	* @param {number} nic
	* @param {string} netname
	* @param {function(?err)} callback
###
exports.set_hostonly = (vm, nic, netname, callback) ->
	command.exec 'modifyvm', vm, "--nic#{nic}", 'hostonly', "--hostonlyadapter#{nic}", netname, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot set hostonly network for nic #{nic} on #{vm}" if code > 0
		return do callback if callback

###
	* Sets internal network adaptor on vm.
	*
	* @param {string} vm
	* @param {number} nic
	* @param {string} netname
	* @param {function(?err)} callback
###
exports.set_internal = (vm, nic, netname, callback) ->
	command.exec 'modifyvm', vm, "--nic#{nic}", 'intnet', "--intnet#{nic}", netname, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot set internal network for nic #{nic} on #{vm}" if code > 0
		return do callback if callback

###
	* Sets nat network adaptor on vm.
	*
	* @param {string} vm
	* @param {number} nic
	* @param {function(?err)} callback
###
exports.set_nat = (vm, nic, callback) ->
	command.exec 'modifyvm', vm, "--nic#{nic}", 'nat', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot set nat netname for nic #{nic} on #{vm}" if code > 0
		return do callback if callback
