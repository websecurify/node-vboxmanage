async = require 'async'
dhcp = require './dhcp.coffee'
share = require './share.coffee'
network = require './network.coffee'

###
	* Configures the system.
	*
	* @param {config}
	* @param {function(?err)} callback
###
exports.system = (config, callback) ->
	actions = []
	
	config.network ?= {}
	config.network.hostonly ?= {}
	config.network.internal ?= {}
	
	configure_dhcp = (nn, nc, add_dhcp, modify_dhcp) ->
		(callback) ->
			dhcp.list_servers (err, servers) ->
				return callback err if err
				
				s = servers.reduce (previous, current) ->
					return previous if previous and previous.NetworkName == nn or previous.NetworkName == "HostInterfaceNetworking-#{nn}"
					return current if current and current.NetworkName == nn or previous.NetworkName == "HostInterfaceNetworking-#{nn}"
					
				h = () ->
					s.IP != nc.ip or
					s.NetworkMask != nc.netmask or
					s.lowerIPAddress != nc.dhcp.lower_ip or
					s.upperIPAddress != nc.dhcp.upper_ip
					
				if s
					if h()
						modify_dhcp nn, nc.ip, nc.netmask, nc.dhcp.lower_ip, nc.dhcp.upper_ip, callback
					else
						return do callback if callback
				else
					 add_dhcp nn, nc.ip, nc.netmask, nc.dhcp.lower_ip, nc.dhcp.upper_ip, callback
					 
	for netname, netconfig of config.network.hostonly
		if netconfig.dhcp?
			actions.push do (netname, netconfig) ->
				configure_dhcp netname, netconfig, dhcp.add_hostonly_server, dhcp.modify_hostonly_server
				
			actions.push do (netname, netconfig) ->
				(callback) ->
					dhcp.enable_hostonly_server netname, callback
					
	for netname, netconfig of config.network.internal
		if netconfig.dhcp?
			actions.push do (netname, netconfig) ->
				configure_dhcp netname, netconfig, dhcp.add_internal_server, dhcp.modify_internal_server
				
			actions.push do (netname, netconfig) ->
				(callback) ->
					dhcp.enable_internal_server netname, callback
					
	if actions.length == 0
		return do callback if callback
	else
		async.series actions, (err) ->
			return err if err
			return do callback if callback

###
	* Configures a vm.
	*
	* @param {string} vm
	* @param {object} config
	* @param {function(?err)} callback
###
exports.machine = (vm, config, callback) ->
	actions = []
	
	config.network ?= {}
	config.network.adaptors ?= []
	config.shares ?= {}
	
	for adaptor, i in config.network.adaptors
		continue if not adaptor.type?
		
		index = i + 1
		
		switch adaptor.type
			when 'hostonly'
				actions.push do (vm, adaptor, index) ->
					(callback) ->
						network.set_hostonly vm, index, adaptor.network, callback
						
			when 'internal'
				actions.push do (vm, adaptor, index) ->
					(callback) ->
						network.set_internal vm, index, adaptor.network, callback
						
			when 'nat'
				actions.push do (vm, adaptor, index) ->
					(callback) ->
						network.set_nat vm, index, callback
						
	for name, path of config.shares
		actions.push do (vm, name, path) ->
			(callback) ->
				share.add_machine_folder vm, name, path, false, false, callback
				
	if actions.length == 0
		return do callback if callback
	else
		async.series actions, (err) ->
			return err if err
			return do callback if callback
