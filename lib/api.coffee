require 'coffee-script'

# ---

utils = require './utils.coffee'
command = require './command.coffee'

# ---

###
	* @param {string} src
	* @param {function(?err)} callback
###
exports.registervm = (src, callback) ->
	command.exec 'registervm', src, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot register #{src}" if code > 0
		return do callback if callback
		
###
	* @param {string} name
	* @param {boolean=} remove
	* @param {function(?err)} callback
###
exports.unregistervm = (name, remove=false, callback) ->
	command.exec 'unregistervm', src, remove ? '--delete' : null, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot unregister #{name}" if code > 0
		return do callback if callback
		
###
	* @param {string} name
	* @param {string=} groups
	* @param {string=} ostype
	* @param {string=} basefolder
	* @param {uuid=} uuid
	* @param {boolean=} register
	* @param {function(?err)} callback
###
exports.createvm = (name, remove=false, groups=null, ostype=null, basefolder=null, uuid=null, register=false, callback) ->
	optionals = []
	
	optionals.push '--groups' and options.push groups if groups
	optionals.push '--ostype' and options.push ostype if ostype
	optionals.push '--basefolder' and options.push basefolder if basefolder
	optionals.push '--uuid' and options.push uuid if uuid
	optionals.push '--register' if register
	
	command.exec 'createvm', '--name', name, optionals..., (err, code, output) ->
		return callback err if err
		return callback new Error "cannot create vm #{name}" if code > 0
		return do callback if callback
		
###
	* @param {string} src
	* @param {string} dst
	* @param {boolean=} register
	* @param {function(?err)} callback
###
exports.clonevm = (src, dst, snapshot=null, mode=null, options=null, register=false, callback) ->
	optionals = []
	
	optionals.push '--register' if register
	
	command.exec 'clonevm', src, '--name', dst, optionals..., (err, code, output) ->
		return callback err if err
		return callback new Error "cannot clone #{src} into #{dst}" if code >0
		return do callback if callback