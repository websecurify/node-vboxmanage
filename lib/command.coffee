path = require 'path'
async = require 'async'
logsmith = require 'logsmith'
child_process = require 'child_process'
stream_buffers = require 'stream-buffers'

###
	* Executes VBoxManage command. Commands are queued in order to prevent race conditions within VirtualBox.
	*
	* @param {string} command
	* @param {array<string>} args
	* @param {function(?err, code, output)} callback
###
exports.exec = do () ->
	vboxmanage_path = switch
		when process.platform.match /^win/ then path.join process.env.VBOX_INSTALL_PATH or '', 'VBoxManage.exe'
		when process.platform.match /^dar/ then '/Applications/VirtualBox.app/Contents/MacOS/VBoxManage'
		else 'VboxManage'
		
	vboxmanage_queue = async.queue (task, callback) ->
		task.run callback
		
	(command, args..., callback) ->
		args = args.filter (arg) -> arg
		args = [].concat.apply [], args
		
		task =
			stream: new stream_buffers.WritableStreamBuffer
			
			run: (callback) ->
				logsmith.verbose "exec #{vboxmanage_path} #{command} #{args.join ' '}"
				
				child = child_process.spawn vboxmanage_path, [command].concat(args)
				
				child.stdout.pipe @stream
				child.stderr.pipe @stream
				
				if logsmith.level in ['debug', 'silly']
					child.stdout.pipe process.stdout
					child.stderr.pipe process.stderr
					
				child.on 'error', (error) => callback error
				child.on 'close', (code) => callback null, code, @stream.getContentsAsString('utf8')
				
		vboxmanage_queue.push task, (err, code, output) ->
			return callback err if err
			return callback null, code, output
