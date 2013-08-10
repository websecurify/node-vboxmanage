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

