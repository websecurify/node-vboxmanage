parse = require './parse.coffee'
proto = require './proto.coffee'
command = require './command.coffee'

###
	* Lists hostonly network interfaces.
	*
	* @param {function(?err, result)} callback
###
exports.list = (callback) ->
	command.exec 'list', 'hostonlyifs', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot list hostonly ifs" if code > 0
		return callback null, parse.linebreak_list(output) if callback

###
	* Creates hostonly interfaces.
	*
	* @param {function(?err)} callback
###
exports.create_if = (callback) ->
	command.exec 'hostonlyif', 'create', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot create hostonly interface" if code > 0
		return do callback if callback

###
	* Removes hostonly interfaces.
	*
	* @param {function(?err)} callback
###
exports.remove_if = (netname, callback) ->
	command.exec 'hostonlyif', 'remove', netname, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot remove hostonly interface #{netname}" if code > 0
		return do callback if callback

###
	* Configures hostonly interfaces.
	*
	* @param {string} netname
	* @param {string} ip
	* @param {string} netmask
	* @param {function(?err)} callback
###
exports.configure_if = (netname, ip, netmask, callback) ->
	command.exec 'hostonlyif', 'ipconfig', netname, '--ip', ip, '--netmask', netmask, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot configure hostonly interface #{netname}" if code > 0
		return do callback if callback

###
	* Ensure hostonly interface.
	*
	* @param {string} netname
	* @param {string} ip
	* @param {string} netmask
	* @param {function(?err)} callback
###
exports.ensure_if = (netname, ip, netmask, callback) ->
	exports.list (err, ifaces) ->
		return callback err if err
		
		iface = ifaces.narrow (previous, current) ->
			return previous if previous and previous.Name == netname
			return current if current and current.Name == netname
			
		if not iface
			callee = arguments.callee
			
			exports.create_if (err) ->
				return callback err if err
				
				exports.list callee
		else
			if iface.IP != ip or iface.NetworkMask != netmask
				exports.configure_if netname, ip, netmask, callback
			else
				return do callback if callback
