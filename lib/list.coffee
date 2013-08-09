parse= require './parse.coffee'
command = require './command.coffee'

# ---

###
	* @param {function(?err, result)} callback
###
exports.os_types = (callback) ->
	command.exec 'list', 'ostypes', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot list os types" if code > 0
		return callback null, parse.linebreak_list(output) if callback
		
###
	* @param {function(?err, result)} callback
###
exports.host_dvds = (callback) ->
	command.exec 'list', 'hostdvds', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot list host dvds" if code > 0
		return callback null, parse.linebreak_list(output) if callback
		
###
	* @param {function(?err, result)} callback
###		
exports.host_floppies = (callback) ->
	command.exec 'list', 'hostfloppies', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot list host floppies" if code > 0
		return callback null, parse.linebreak_list(output) if callback
		
###
	* @param {function(?err, result)} callback
###
exports.bridged_ifs = (callback) ->
	command.exec 'list', 'bridgedifs', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot list bridged ifs" if code > 0
		return callback null, parse.linebreak_list(output) if callback
		
###
	* @param {function(?err, result)} callback
###
exports.hostonly_ifs = (callback) ->
	command.exec 'list', 'hostonlyifs', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot list hostonly ifs" if code > 0
		return callback null, parse.linebreak_list(output) if callback
		
###
	* @param {function(?err, result)} callback
###
exports.host_info = (callback) ->
	command.exec 'list', 'hostinfo', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot list host info" if code > 0
		return callback null, output if callback
		
###
	* @param {function(?err, result)} callback
###
exports.host_cpu_ids = (callback) ->
	command.exec 'list', 'hostcpuids', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot list host cpu ids" if code > 0
		return callback null, output if callback
		
###
	* @param {function(?err, result)} callback
###
exports.hdd_backends = (callback) ->
	command.exec 'list', 'hddbackends', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot list hdd backends" if code > 0
		return callback null, output if callback
		
###
	* @param {function(?err, result)} callback
###
exports.hdds = (callback) ->
	command.exec 'list', 'hdds', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot list hdds" if code > 0
		return callback null, parse.linebreak_list(output) if callback
		
###
	* @param {function(?err, result)} callback
###
exports.dvds = (callback) ->
	command.exec 'list', 'dvds', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot list dvds" if code > 0
		return callback null, parse.linebreak_list(output) if callback
		
###
	* @param {function(?err, result)} callback
###
exports.floppies = (callback) ->
	command.exec 'list', 'floppies', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot list floppies" if code > 0
		return callback null, parse.linebreak_list(output) if callback
		
###
	* @param {function(?err, result)} callback
###
exports.usb_hosts = (callback) ->
	command.exec 'list', 'usbhosts', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot list usb hosts" if code > 0
		return callback null, parse.linebreak_list(output) if callback
		
###
	* @param {function(?err, result)} callback
###
exports.usb_filters = (callback) ->
	command.exec 'list', 'usbfilters', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot list usb filters" if code > 0
		return callback null, parse.linebreak_list(output) if callback
		
###
	* @param {function(?err, result)} callback
###
exports.system_properties = (callback) ->
	command.exec 'list', 'systemproperties', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot list system properties" if code > 0
		return callback null, parse.linebreak_list(output)[0] if callback
		
###
	* @param {function(?err, result)} callback
###
exports.ext_packs = (callback) ->
	command.exec 'list', 'extpacks', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot list ext packs" if code > 0
		return callback null, parse.linebreak_list(output)[0] if callback
		
###
	* @param {function(?err, result)} callback
###
exports.groups = (callback) ->
	command.exec 'list', 'groups', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot list groups" if code > 0
		return callback null, output if callback
		