fs = require 'fs'
path = require 'path'
completions = null

fs.readFile path.resolve(__dirname, '..', 'completions.json'), (error, content) =>
	completions = JSON.parse(content) unless error?

firstCharsEqual = (str1, str2) ->
	str2.length >= str1.length and str1.toUpperCase() is str2.substring(0,str1.length).toUpperCase()

module.exports =
class AblProvider
	selector: '.source.abl'
	disableForSelector: '.source.abl .comment'

	getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
		new Promise (resolve) ->
			vls = []
			#for value in completions when -1 isnt (value.text.toLowerCase()).indexOf prefix
			#for value in completions when 0 is (value.text.toLowerCase()).indexOf prefix
			typeAttribMethod = false
			for scope in scopeDescriptor.scopes when -1 isnt scope.indexOf 'attribute' or -1 isnt scope.indexOf 'method'
				typeAttribMethod = true
			for value in completions when firstCharsEqual(prefix,value.text)
				value.replacementPrefix = prefix
				if typeAttribMethod
					if value.type is 'attribute' or value.type is 'method'
						vls.push(value)
				else
					vls.push(value)

			resolve(vls)
