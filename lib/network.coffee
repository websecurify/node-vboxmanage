command = require './command.coffee'
property = require './property.coffee'

# ---

###
	* @param {string} name
	* @param {function(?err, result)} callback
###
exports.list_adaptors = (name, callback) ->
	property.enumerate name, (err, result) ->
		return callback err if err
		
		adaptors = {}
		
		for key, val of result
			match = key.match /^\/VirtualBox\/GuestInfo\/Net\/(\d+)\/(.+?)$/
			
			continue if not match
			
			index = parseInt(match[1])
			path = match[2]
			ref = adaptors["vboxnet#{index}"] ?= {}
			
			for key in path.split('/')
				path = key
				ref = ref[path] ?= {}
				
			ref[path] = val.value
			
		callback null, adaptors if callback
		
###
	* Sets hostonly network adaptor on vm.
	*
	* @param {string} vm
	* @param {number} nic
	* @param {string} network
	* @param {function(?err)} callback
###
exports.set_hostonly = (vm, nic, network, callback) ->
	command.exec 'modifyvm', vm, "--nic#{nic}", 'hostonly', "--hostonlyadapter#{nic}", network, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot set hostonly network for nic #{nic} on #{vm}" if code > 0
		return do callback if callback
		
###
	* Sets internal network adaptor on vm.
	*
	* @param {string} vm
	* @param {number} nic
	* @param {string} network
	* @param {function(?err)} callback
###
exports.set_internal = (vm, nic, network, callback) ->
	command.exec 'modifyvm', vm, "--nic#{nic}", 'intnet', "--intnet#{nic}", network, (err, code, output) ->
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
		return callback new Error "cannot set nat network for nic #{nic} on #{vm}" if code > 0
		return do callback if callback
		