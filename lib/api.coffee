fs = require 'fs'
async = require 'async'
child_process = require 'child_process'

# ---

vboxmanage_path = do () ->
	vboxmanage_path = null
	
	if process.platform.match /^win/
		vboxmanage_path = process.env.VBOX_INSTALL_PATH?.split(process.delimiter).reduce (previous, current, index, array) ->
			return previous if previous
			
			current = path.join current, 'VboxManage.exe'
			
			return current if fs.existsSync(current)
		, null
		
		return vboxmanage_path or 'VboxManage.exe'
		
	if process.platform.match /^dar/
		vboxmanage_path = '/Applications/VirtualBox.app/Contents/MacOS/VBoxManage'
		vboxmanage_path = vboxmanage_path if fs.existsSync(vboxmanage_path) else null
		
		return vboxmanage_path or 'VBoxManage'
		
	return vboxmanage_path
	
# ---

command_queue = async.queue (task, callback) ->
	task.run callback
	
# ---

###
	* @param {string} command
	* @param {array} args
	* @param {function} callback
###
exports.command = (command, args..., callback) ->
	taks =
		output: []
		code: 0
		
		run: (callback) =>
			child = child_process.spawn @vboxmanage, [command].concat(args)
			
			child.on 'error', (error) =>
				callback()
			
			child.on 'close', (code) =>
				@code = code
	
	command_queue.push task, (err) ->
		return callback err if err
		return callback null, task.output, task.code
	
###
	* @param {string} path
	* @param {string} name
	* @param {function} callback
###
exports.importvm = (path, name, callback) ->
	exports.command 'importvm', path, '--vsys', '0', '--vmname', name, (err, output, code) ->
		return callback err if err
		return callback new Error("cannot import #{location} into #{name}") if code > 0
		
		callback()
