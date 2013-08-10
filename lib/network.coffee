parse = require './parse.coffee'
machine = require './machine.coffee'
command = require './command.coffee'

###
	* Lists bridged network interfaces.
	*
	* @param {function(?err, result)} callback
###
exports.list_bridged_ifs = (callback) ->
	command.exec 'list', 'bridgedifs', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot list bridged ifs" if code > 0
		return callback null, parse.linebreak_list(output) if callback

###
	* Lists hostonly network interfaces.
	*
	* @param {function(?err, result)} callback
###
exports.list_hostonly_ifs = (callback) ->
	command.exec 'list', 'hostonlyifs', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot list hostonly ifs" if code > 0
		return callback null, parse.linebreak_list(output) if callback

###
###
exports.create_hostonly_if = (callback) ->
	command.exec 'hostonlyif', 'create', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot create hostonly interface" if code > 0
		return do callback if callback

###
###
exports.remove_hostonly_if = (netname, callback) ->
	command.exec 'hostonlyif', 'remove', netname, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot remove hostonly interface #{netname}" if code > 0
		return do callback if callback

###
###
exports.configure_hostonly_if = (netname, ip, netmask, callback) ->
	command.exec 'hostonlyif', 'ipconfig', netname, '--ip', ip, '--netmask', netmask, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot configure hostonly interface #{netname}" if code > 0
		return do callback if callback

###
	* @param {string} vm
	* @param {function(?err, result)} callback
###
exports.list_adaptors = (vm, callback) ->
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
