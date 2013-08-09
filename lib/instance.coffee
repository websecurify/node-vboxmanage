parse= require './parse.coffee'
command = require './command.coffee'

###
	* List running vms.
	*
	* @param {function(?err, result)} callback
###
exports.list = (callback) ->
	command.exec 'list', 'runningvms', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot list running vms" if code > 0
		return callback null, parse.namepair_list(output) if callback

###
	* Starts vm.
	*
	* @param {string} vm
	* @param {function(?err, ?headless, callback)}
###
exports.start = (vm, callback) ->
	command.exec 'startvm', vm, '--type', 'headless', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot start #{vm}" if code > 0
		return do callback if callback

###
	* Stops vm.
	*
	* @param {string} vm
	* @param {function(?err)}
###
exports.stop = (vm, callback) ->
	command.exec 'controlvm', vm, 'poweroff', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot stop #{vm}" if code > 0
		return do callback if callback

###
	* Pauses vm.
	*
	* @param {string} vm
	* @param {function(?err)}
###
exports.pause = (vm, callback) ->
	command.exec 'controlvm', 'pause', vm, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot pause #{vm}" if code > 0
		return do callback if callback

###
	* Resumes vm.
	*
	* @param {string} vm
	* @param {function(?err)}
###
exports.resume = (vm, callback) ->
	command.exec 'controlvm', 'resume', vm, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot resume #{vm}" if code > 0
		return do callback if callback

###
	* Executes command on vm.
	*
	* @param {string} vm
	* @param {string} user
	* @param {string} pass
	* @param {string} path
	* @param {array<string>} args
	* @param {function(?err, output)}
###
exports.exec = (vm, user, pass, path, args..., callback) ->
	must = []
	
	must.push('--username') and must.push(user)
	must.push('--password') and must.push(pass)
	must.push('--wait-exit')
	must.push('--wait-stdout')
	must.push('--wait-stderr')
	
	command.exec 'guestcontrol', vm, 'execute', must..., path, '--', args..., (err, code, output) ->
		return callback err if err
		return callback new Error "cannot exec #{path} #{args.join ' '} on #{vm}" if code > 0
		return callback null, output if callback

###
	* Copies from guest to host.
	*
	* @param {string} vm
	* @param {string} user
	* @param {string} pass
	* @param {string} from_guest
	* @param {string} to_host
###
exports.copy_from = (vm, user, pass, from_guest, to_host) ->
	must = []
	
	must.push('--username') and must.push(user)
	must.push('--password') and must.push(pass)
	must.push('--verbose')
	must.push('--follow')
	must.push('--recursive')
	
	command.exec 'guestcontrol', vm, 'copyfrom', from_guest, to_host, must..., (err, code, output) ->
		return callback err if err
		return callback new Error "cannot copy from guest #{from_guest} to host #{to_host} on #{vm}" if code > 0
		return do callback if callback

###
	* Copies from host to guest.
	*
	* @param {string} vm
	* @param {string} user
	* @param {string} pass
	* @param {string} from_host
	* @param {string} to_guest
###
exports.copy_to = (vm, user, pass, from_host, to_guest) ->
	must = []
	
	must.push('--username') and must.push(user)
	must.push('--password') and must.push(pass)
	must.push('--verbose')
	must.push('--follow')
	must.push('--recursive')
	
	command.exec 'guestcontrol', vm, 'copyto', from_host, to_guest, must..., (err, code, output) ->
		return callback err if err
		return callback new Error "cannot copy from host #{from_host} to guest #{to_guest} on #{vm}" if code > 0
		return do callback if callback
