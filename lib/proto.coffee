###
	* @param {*=} initial_value
	* @param {function(current, previous, index, array)} callback
###
Array::narrow = (initial_value, callback) ->
	if not callback? then [callback, initial_value] = [initial_value, null]
	
	@reduce callback, initial_value
