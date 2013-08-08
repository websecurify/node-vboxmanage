winston = require 'winston'

# ---

module.exports = new winston.Logger({
	transports: [
		new winston.transports.Console({prettyPrint : true})
	]
})

# ---

exports.exception = (exception) ->
	module.exports.debug(exception.message, exception);
	