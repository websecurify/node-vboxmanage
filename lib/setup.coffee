async = require 'async'
dhcp = require './dhcp.coffee'
proto = require './proto.coffee'
share = require './share.coffee'
hostonly = require './hostonly.coffee'
adaptors = require './adaptors.coffee'

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
	
	for netname, netconfig of config.network.hostonly
		return callback new Error "no ip specified for hostonly network #{netname}" if not netconfig.ip?
		return callback new Error "no netmask specified for hostonly network #{netname}" if not netconfig.netmask?
		
		actions.push do (netname, netconfig) ->
			(callback) ->
				hostonly.ensure_if netname, netconfig.ip, netconfig.netmask, callback
				
		if netconfig.dhcp?
			return callback new Error "no lower_ip specified for hostonly network #{netname} dhcp" if not netconfig.dhcp.lower_ip?
			return callback new Error "no upper_ip specified for hostonly network #{netname} dhcp" if not netconfig.dhcp.upper_ip?
			
			actions.push do (netname, netconfig) ->
				(callback) ->
					dhcp.ensure_hostonly_server netname, netconfig.ip, netconfig.netmask, netconfig.dhcp.lower_ip, netconfig.dhcp.upper_ip, callback
				
			actions.push do (netname, netconfig) ->
				(callback) ->
					dhcp.enable_hostonly_server netname, callback
					
	for netname, c of config.network.internal
		return callback new Error "no ip specified for internal network #{netname}" if not netconfig.ip?
		return callback new Error "no netmask specified for internal network #{netname}" if not netconfig.netmask?
		
		if netconfig.dhcp?
			return callback new Error "no lower_ip specified for internal network #{netname} dhcp" if not netconfig.dhcp.lower_ip?
			return callback new Error "no upper_ip specified for internal network #{netname} dhcp" if not netconfig.dhcp.upper_ip?
			
			actions.push do (netname, netconfig) ->
				(callback) ->
					dhcp.ensure_internal_server netname, netconfig.ip, netconfig.netmask, netconfig.dhcp.lower_ip, netconfig.dhcp.upper_ip, callback
				
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
		return callback new Error "no type specified for adaptor" if not adaptor.type?
		
		index = i + 1
		
		switch adaptor.type
			when 'hostonly'
				return callback new Error "no network specified for adaptor" if not adaptor.network?
				
				actions.push do (vm, adaptor, index) ->
					(callback) ->
						adaptors.set_hostonly vm, index, adaptor.network, callback
						
			when 'internal'
				return callback new Error "no network specified for adaptor" if not adaptor.network?
				
				actions.push do (vm, adaptor, index) ->
					(callback) ->
						adaptors.set_internal vm, index, adaptor.network, callback
						
			when 'nat'
				actions.push do (vm, adaptor, index) ->
					(callback) ->
						adaptors.set_nat vm, index, callback
						
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
