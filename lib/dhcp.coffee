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
	* Adds hostonly dhcp server. The server is not enables by default.
	*
	* @param {string} netname
	* @param {string} ip
	* @param {string} netmask
	* @param {string} lower_ip
	* @param {string} upper_ip
	* @param {function(?err)} callback
###
exports.add_hostonly_server = (netname, ip, netmask, lower_ip, upper_ip, callback) ->
	opts = []
	
	opts.push('--ip') and opts.push(ip)
	opts.push('--netmask') and opts.push(netmask)
	opts.push('--lowerip') and opts.push(lower_ip)
	opts.push('--upperip') and opts.push(upper_ip)
	
	command.exec 'dhcpserver', 'add', '--ifname', netname, opts..., (err, code, output) ->
		return callback err if err
		return callback new Error "cannot add hostonly dhcp server on #{netname}" if code > 0
		return do callback if callback

###
	* Removes hostonly dhcp server.
	*
	* @param {string} netname
	* @param {function(?err)} callback
###
exports.remove_hostonly_server = (netname, callback) ->
	command.exec 'dhcpserver', 'remove', '--ifname', netname, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot remove hostonly dhcp server on #{netname}" if code > 0
		return do callback if callback

###
	* Modifies hostonly dhcp server
	*
	* @param {string} netname
	* @param {string} ip
	* @param {string} netmask
	* @param {string} lower_ip
	* @param {string} upper_ip
	* @param {function(?err)} callback
###
exports.modify_hostonly_server = (netname, ip, netmask, lower_ip, upper_ip, callback) ->
	opts = []
	
	opts.push('--ip') and opts.push(ip)
	opts.push('--netmask') and opts.push(netmask)
	opts.push('--lowerip') and opts.push(lower_ip)
	opts.push('--upperip') and opts.push(upper_ip)
	
	command.exec 'dhcpserver', 'modify', '--ifname', netname, opts..., (err, code, output) ->
		return callback err if err
		return callback new Error "cannot modify hostonly dhcp server on #{netname}" if code > 0
		return do callback if callback

###
	* Enables hostonly dhcp server.
	*
	* @param {string} netname
	* @param {function(?err)} callback
###
exports.enable_hostonly_server = (netname, callback) ->
	command.exec 'dhcpserver', 'modify', '--ifname', netname, '--enable', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot enable hostonly dhcp server on #{netname}" if code > 0
		return do callback if callback

###
	* Disables hostonly dhcp server.
	*
	* @param {string} netname
	* @param {function(?err)} callback
###
exports.disable_hostonly_server = (netname, callback) ->
	command.exec 'dhcpserver', 'modify', '--ifname', netname, '--disable', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot disable hostonly dhcp server on #{netname}" if code > 0
		return do callback if callback

###
	* Adds internal dhcp server. The server is not enabled by default.
	*
	* @param {string} netname
	* @param {string} ip
	* @param {string} netmask
	* @param {string} lower_ip
	* @param {string} upper_ip
	* @param {function(?err)} callback
###
exports.add_internal_server = (netname, ip, netmask, lower_ip, upper_ip, callback) ->
	opts = []
	
	opts.push('--ip') and opts.push(ip)
	opts.push('--netmask') and opts.push(netmask)
	opts.push('--lowerip') and opts.push(lower_ip)
	opts.push('--upperip') and opts.push(upper_ip)
	
	command.exec 'dhcpserver', 'add', '--netname', netname, opts..., (err, code, output) ->
		return callback err if err
		return callback new Error "cannot add internal dhcp server on #{netname}" if code > 0
		return do callback if callback

###
	* Removes internal dhcp server.
	*
	* @param {string} netname
	* @param {function(?err)} callback
###
exports.remove_internal_server = (netname, callback) ->
	command.exec 'dhcpserver', 'remove', '--netname', netname, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot remove internal dhcp server on #{netname}" if code > 0
		return do callback if callback

###
	* Modifies internal dhcp server.
	*
	* @param {string} netname
	* @param {string} ip
	* @param {string} netmask
	* @param {string} lower_ip
	* @param {string} upper_ip
	* @param {function(?err)} callback
###
exports.modify_internal_server = (netname, ip, netmask, lower_ip, upper_ip, callback) ->
	opts = []
	
	opts.push('--ip') and opts.push(ip)
	opts.push('--netmask') and opts.push(netmask)
	opts.push('--lowerip') and opts.push(lower_ip)
	opts.push('--upperip') and opts.push(upper_ip)
	
	command.exec 'dhcpserver', 'modify', '--netname', netname, opts..., (err, code, output) ->
		return callback err if err
		return callback new Error "cannot modify internal dhcp server on #{netname}" if code > 0
		return do callback if callback

###
	* Enables internal dhcp server.
	*
	* @param {string} netname
	* @param {function(?err)} callback
###
exports.enable_internal_server = (netname, callback) ->
	opts = []
	
	opts.push('--enable')
	
	command.exec 'dhcpserver', 'modify', '--netname', netname, opts..., (err, code, output) ->
		return callback err if err
		return callback new Error "cannot enable internal dhcp server on #{netname}" if code > 0
		return do callback if callback

###
	* Disables internal dhcp server.
	*
	* @param {string} netname
	* @param {function(?err)} callback
###
exports.disable_internal_server = (netname, callback) ->
	opts = []
	
	opts.push('--disable')
	
	command.exec 'dhcpserver', 'modify', '--netname', netname, opts..., (err, code, output) ->
		return callback err if err
		return callback new Error "cannot disable internal dhcp server on #{netname}" if code > 0
		return do callback if callback
