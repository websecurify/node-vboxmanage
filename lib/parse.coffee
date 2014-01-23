to_value = (value) ->
	return switch value
		when 'none' then null
		when 'on' then true
		when 'off' then false
		when 'true' then true
		when 'false' then false
		else value

to_object = (previous, current) ->
	previous[key] = to_value(val) for key, val of current if current
	
	return previous

to_array = (previous, current) ->
	previous.push({}) if previous.length == 0 or current == null
	
	previous[previous.length - 1][key] = to_value(val) for key, val of current if current
	
	return previous

###
	@param {string} info
###
exports.linebreak_list = (input) ->
	to_item = (line) ->
		return null if not line
		
		line = line.replace(/^(.+?):\s*/, '"$1":"') + '"'
		
		return JSON.parse("{#{line}}")
		
	return input.split('\n').map(to_item).reduce(to_array, []).filter((item) -> Object.keys(item).length > 0)

###
	* @param {string} input
###
exports.namepair_list = (input) ->
	to_item = (line) ->
		line = line.replace(/" {/, '":"{')
		line = line + '"' if line
		
		return JSON.parse("{#{line}}")
		
	return input.split('\n').map(to_item).reduce(to_object)
	
###
	* @param {string} input
###
exports.machinereadable_list = (input) ->
	to_item = (line) ->
		line = line.replace(/^(.+)=/, '"$1"=') if line[0] != '"'
		line = line.replace(/^(".+")=/, '$1:')
		line = line.replace(/^(.+):\d+,/, '$1:0.')
		line = line.replace(/@\d,\d$/, '')
		
		return JSON.parse("{#{line}}")
		
	return input.split('\n').map(to_item).reduce(to_object)
	
###
	* @param {string} input
###
exports.property_list = (input) ->
	to_item = (line) ->
		item = {}
		
		return item if not line
		
		match = line.match(/^Name:\s*(.*?),\s*value:\s*(.*?),\s*timestamp:\s*(.*?),\s*flags:\s*(.*?)$/)
		
		return item if not match
		
		item[match[1]] = {
			value: to_value(match[2])
			timestamp: parseInt(match[3])
			flags: match[4].split(',').map((token) -> token.trim())
		}
		
		return item
		
	return input.split('\n').map(to_item).reduce(to_object)
