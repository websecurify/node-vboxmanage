parse = require './parse.coffee'
command = require './command.coffee'

###
	* Lists available dhcp servers.
	*
	* @param {function(?err, result)} callback
###
exports.list_servers = (callback) ->
	command.exec 'list', 'dhcpservers', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot list dhcp servers" if code > 0
		return callback null, parse.linebreak_list(output) if callback

###
	* Adds hostonly dhcp server. The server is not enabled by default.
	*
	* @param {string} network
	* @param {string} ip
	* @param {string} netmask
	* @param {function(?err)} callback
###
exports.add_hostonly_server = (network, ip, netmask, callback) ->
	command.exec 'dhcpserver', 'add', '--ifname', network, '--ip', ip, '--netmask', netmask, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot add hostonly dhcp server on #{network}" if code > 0
		return do callback if callback

###
	* Removes hostonly dhcp server.
	*
	* @param {string} network
	* @param {function(?err)} callback
###
exports.remove_hostonly_server = (network, callback) ->
	command.exec 'dhcpserver', 'remove', '--ifname', network, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot remove hostonly dhcp server on #{network}" if code > 0
		return do callback if callback

###
	* Modifies hostonly dhcp server
	*
	* @param {string} network
	* @param {string} ip
	* @param {string} netmask
	* @param {function(?err)} callback
###
exports.modify_hostonly_server = (network, ip, netmask, callback) ->
	command.exec 'dhcpserver', 'modify', '--ifname', network, '--ip', ip, '--netmask', netmask, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot modify hostonly dhcp server on #{network}" if code > 0
		return do callback if callback

###
	* Enables hostonly dhcp server.
	*
	* @param {string} network
	* @param {function(?err)} callback
###
exports.enable_hostonly_server = (network, enable, callback) ->
	command.exec 'dhcpserver', 'modify', '--ifname', network, '--enable', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot enable hostonly dhcp server on #{network}" if code > 0
		return do callback if callback

###
	* Disables hostonly dhcp server.
	*
	* @param {string} network
	* @param {function(?err)} callback
###
exports.disable_hostonly_server = (network, enable, callback) ->
	command.exec 'dhcpserver', 'modify', '--ifname', network, '--disable', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot disable hostonly dhcp server on #{network}" if code > 0
		return do callback if callback

###
	* Adds internal dhcp server. The server is not enabled by default.
	*
	* @param {string} network
	* @param {string} ip
	* @param {string} netmask
	* @param {function(?err)} callback
###
exports.add_internal_server = (network, ip, netmask, callback) ->
	command.exec 'dhcpserver', 'add', '--netname', network, '--ip', ip, '--netmask', netmask, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot add internal dhcp server on #{network}" if code > 0
		return do callback if callback

###
	* Removes internal dhcp server.
	*
	* @param {string} network
	* @param {function(?err)} callback
###
exports.remove_internal_server = (network, callback) ->
	command.exec 'dhcpserver', 'remove', '--network', network, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot remove internal dhcp server on #{network}" if code > 0
		return do callback if callback

###
	* Modifies internal dhcp server.
	*
	* @param {string} network
	* @param {string} ip
	* @param {string} netmask
	* @param {function(?err)} callback
###
exports.modify_internal_server = (network, ip, netmask, callback) ->
	command.exec 'dhcpserver', 'modify', '--ifname', network, '--ip', ip, '--netmask', netmask, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot modify internal dhcp server on #{network}" if code > 0
		return do callback if callback

###
	* Enables internal dhcp server.
	*
	* @param {string} network
	* @param {function(?err)} callback
###
exports.enable_internal_server = (network, enable, callback) ->
	command.exec 'dhcpserver', 'modify', '--network', network, '--enable', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot enable internal dhcp server on #{network}" if code > 0
		return do callback if callback

###
	* Disables internal dhcp server.
	*
	* @param {string} network
	* @param {function(?err)} callback
###
exports.disable_internal_server = (network, enable, callback) ->
	command.exec 'dhcpserver', 'modify', '--network', network, '--disable', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot disable internal dhcp server on #{network}" if code > 0
		return do callback if callback
