###
	* @param {string} info
###
exports.parse_info = (info) ->
	to_item = (line) ->
		line = line.replace(/^(.+)=/, '"$1"=') if line[0] != '"'	
		line = line.replace(/^(".+")=/, '$1:')
		
		return JSON.parse("{#{line}}")
		
	to_value = (value) ->
		return switch value
			when 'none' then null
			when 'on' then true
			when 'off' then false
			else value
			
	to_object = (previous, current) ->
		previous[key] = to_value(val) for key, val of current if current
		
		return previous
		
	return info.split('\n').map(to_item).reduce(to_object)
	