fs = require 'fs'
path = require 'path'
completions = null

fs.readFile path.resolve(__dirname, '..', 'completions.json'), (error, content) =>
	completions = JSON.parse(content) unless error?

firstCharsEqual = (prefix, text) ->
	text.toUpperCase().indexOf(prefix.toUpperCase()) is 0
	#text.length >= prefix.length and prefix.toUpperCase() is text.substring(0,prefix.length).toUpperCase()
otherCharsEqual = (prefix,text) ->
	 text.toUpperCase().indexOf(prefix.toUpperCase()) > 0

addType = (arr, types, prefix) ->
	for value in completions when firstCharsEqual(prefix,value.text) and -1 isnt types.indexOf value.type
		value.replacementPrefix = prefix
		arr.push(value)
	for value in completions when otherCharsEqual(prefix,value.text) and -1 isnt types.indexOf value.type
		value.replacementPrefix = prefix
		arr.push(value)


module.exports =
class AblProvider
	selector: '.source.abl'
	disableForSelector: '.source.abl .comment'

	getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
		new Promise (resolve) ->
			vls = []
			console.log(prefix)
			scope = scopeDescriptor.scopes.join(',')
			if -1 isnt scope.indexOf 'attribute' or -1 isnt scope.indexOf 'method'
				addType(vls,['attribute','method'],prefix)
			else if -1 isnt scope.indexOf 'preprocessor'
				addType(vls,['preprocessor'],prefix)
			else
				for value in completions when firstCharsEqual(prefix,value.text)
					value.replacementPrefix = prefix
					vls.push(value)
				for value in completions when otherCharsEqual(prefix,value.text)
					value.replacementPrefix = prefix
					vls.push(value)

			resolve(vls)
