require 'coffee-script'

# ---

async = require 'async'
child_process = require 'child_process'
stream_buffers = require 'stream-buffers'

# ---

logger = require './logger.coffee'

# ---

###
	* @param {string} command
	* @param {array} args
	* @param {function(?err, code, output)} callback
###
exports.exec = do () ->
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
				logger.verbose "exec #{vboxmanage_path} #{command} #{args.join ' '}"
				
				child = child_process.spawn vboxmanage_path, [command].concat(args)
				
				child.stdout.pipe @stream
				child.stderr.pipe @stream
				child.on 'error', (error) => callback error
				child.on 'close', (code) => callback null, code, @stream.getContentsAsString('utf8')
				
		command_queue.push task, (err, code, output) ->
			return callback err if err
			return callback null, code, output
			