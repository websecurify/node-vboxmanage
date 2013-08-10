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
	
	for n, c of config.network.hostonly
		actions.push do (n, c) ->
			(callback) ->
				hostonly.ensure_if n, c.ip, c.netmask, callback
				
		if c.dhcp?
			actions.push do (n, c) ->
				(callback) ->
					dhcp.ensure_hostonly_server n, c.ip, c.netmask, c.dhcp.lower_ip, c.dhcp.upper_ip, callback
				
			actions.push do (n, c) ->
				(callback) ->
					dhcp.enable_hostonly_server n, callback
					
	for n, c of config.network.internal
		if c.dhcp?
			actions.push do (n, c) ->
				(callback) ->
					dhcp.ensure_internal_server n, c.ip, c.netmask, c.dhcp.lower_ip, c.dhcp.upper_ip, callback
				
			actions.push do (n, c) ->
				(callback) ->
					dhcp.enable_internal_server n, callback
					
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
				actions.push do (vm, adaptor, index) ->
					(callback) ->
						return callback new Error "no network specified for adaptor" if not adaptor.network?
						
						adaptors.set_hostonly vm, index, adaptor.network, callback
						
			when 'internal'
				actions.push do (vm, adaptor, index) ->
					(callback) ->
						return callback new Error "no network specified for adaptor" if not adaptor.network?
						
						adaptors.set_internal vm, index, adaptor.network, callback
						
			when 'nat'
				actions.push do (vm, adaptor, index) ->
					(callback) ->
						adaptros.set_nat vm, index, callback
						
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
