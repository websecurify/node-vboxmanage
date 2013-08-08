require 'coffee-script'

# ---

async = require 'async'
child_process = require 'child_process'
stream_buffers = require 'stream-buffers'

# ---

utils = require './utils.coffee'
logger = require './logger.coffee'

# ---

###
	* @param {string} command
	* @param {array} args
	* @param {function(?err, code, output)} callback
###
exports.command = do () ->
	vboxmanage_path = switch
		when process.platform.match /^win/ then path.join process.env.VBOX_INSTALL_PATH or '', 'VBoxManage.exe'
		when process.platform.match /^dar/ then '/Applications/VirtualBox.app/Contents/MacOS/VBoxManage'
		else 'VboxManage'
		
	command_queue = async.queue (task, callback) ->
		task.run callback
		
	(command, args..., callback) ->
		args = args.filter (arg) -> arg
		
		task =
			stream: new stream_buffers.WritableStreamBuffer
			
			run: (callback) ->
				logger.verbose "exec #{vboxmanage_path} #{command} #{args.join(' ')}"
				
				child = child_process.spawn vboxmanage_path, [command].concat(args)
				
				child.stdout.pipe @stream
				child.stderr.pipe @stream
				child.on 'error', (error) => callback error
				child.on 'close', (code) => callback null, code, @stream.getContentsAsString('utf8')
				
		command_queue.push task, (err, code, output) ->
			return callback err if err
			return callback null, code, output
			
# ---

###
	* @param {string} name
	* @param {function(?err, result)} callback
###
exports.showvminfo = (name, callback) ->
	exports.command 'showvminfo', name, '--machinereadable', (err, code, output) ->
		return callback err if err
		return callback new Error "cannot show info for #{name}" if code > 0
		return callback null, utils.parse_info(output)
		
# ---

###
	* @param {string} src
	* @param {string} dst
	* @param {boolean=} register
	* @param {function(?err)} callback
###
exports.clonevm = (src, dst, register=true, callback) ->
	exports.command 'clonevm', src, '--name', dst, register ? '--register' : null, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot clone #{src} into #{dst}" if code >0
		return do callback if callback
		
# ---

###
	* @param {string} path
	* @param {string} name
	* @param {function(?err)} callback
###
exports.import = (path, name, callback) ->
	exports.command 'import', path, '--vsys', '0', '--vmname', name, (err, code, output) ->
		return callback err if err
		return callback new Error "cannot import #{location} into #{name}" if code > 0		
		return do callback if callback
		