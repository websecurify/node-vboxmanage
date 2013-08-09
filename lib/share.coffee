machine = require './machine.coffee'
command = require './command.coffee'

###
	* Lists folders.
	*
	* @param {function(?err, result)} callback
###
exports.list_folders = (vm, callback) ->
	machine.info vm, (err, info) ->
		return callback err if err
		
		mappings = {}
		folders = {}
		
		for key, val of info
			match = key.match /SharedFolder(Name|Path)(Machine|Transient)Mapping(\d+)/
			
			continue if not match
			
			property = match[1].toLowerCase()
			type = match[2].toLowerCase()
			id = match[3]
			path = "#{type}#{id}"
			
			folders[type] ?= {}
			
			switch property
				when 'name' then mappings[path] = val
				when 'path' then folders[type][mappings[path]] = val
				
		return callback null, folders if callback

###
	* Adds machine folder.
	*
	* @param {string} vm
	* @param {string} name
	* @param {string} path
	* @param {boolean} readonly
	* @param {boolean} automount
	* @param {function(?err)} callback
###
exports.add_machine_folder = (vm, name, path, readonly, automount, callback) ->
	optionals = []
	
	optionals.push('--readonly') if readonly
	optionals.push('--automount') if automount
	
	command.exec 'sharedfolder', 'add', vm, '--name', name, '--hostpath', path, optionals..., (err, code, output) ->
		return callback err if err
		return callback new Error "cannot add machine folder #{name} on #{vm}" if code > 0
		return do callback if callback

###
	* Removes machine folder.
	*
	* @param {string} vm
	* @param {string} name
	* @param {function(?err)} callback
###
exports.remove_machine_folder = (vm, name, callback) ->
	command.exec 'sharedfolder', 'remove', vm, '--name', name, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot remove machine folder #{name} on #{vm}" if code > 0
		return do callback if callback

###
	* Adds transient folder.
	*
	* @param {string} vm
	* @param {string} name
	* @param {string} path
	* @param {boolean} readonly
	* @param {boolean} automount
	* @param {function(?err)} callback
###
exports.add_transient_folder = (vm, name, path, readonly, automount, callback) ->
	optionals = []
	
	optionals.push('--readonly') if readonly
	optionals.push('--automount') if automount
	
	command.exec 'sharedfolder', 'add', vm, '--name', name, '--hostpath', path, '--transient', optionals..., (err, code, output) ->
		return callback err if err
		return callback new Error "cannot add transient folder #{name} on #{vm}" if code > 0
		return do callback if callback

###
	* Removes transient folder.
	*
	* @param {string} vm
	* @param {string} name
	* @param {function(?err)} callback
###
exports.remove_transient_folder = (vm, name, callback) ->
	command.exec 'sharedfolder', 'remove', vm, '--name', name, '--transient', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot remove transient folder #{name} on #{vm}" if code > 0
		return do callback if callback
