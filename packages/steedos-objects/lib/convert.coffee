Meteor.startup ()->
	Creator.convertObject = (object)->
		_.forEach object.triggers, (trigger, key)->

			if (Meteor.isServer && trigger.on == "server") || (Meteor.isClient && trigger.on == "client")
				_todo = trigger.todo
				if _todo && _.isString(_todo)
					#只有update时， fieldNames, modifier, options 才有值
					#TODO 控制可使用的变量，尤其是Collection
					trigger.todo = Creator.eval("(function(userId, doc, fieldNames, modifier, options){#{_todo}})")

		if Meteor.isClient
			_.forEach object.actions, (action, key)->
				_todo = action?.todo
				if _todo && _.isString(_todo)
					#TODO 控制可使用的变量
					action.todo = Creator.eval("(function(){#{_todo}})")

		_.forEach object.fields, (field, key)->
			if field.options && _.isString(field.options)
				try
					_options = []
					_.forEach field.options.split("\n"), (option)->
						foo = option.split(":")
						if foo.length > 1
							_options.push {label: foo[0], value: foo[1]}
						else
							_options.push {label: foo[0], value: foo[0]}
					field.options = _options
				catch error
					console.error "Creator.convertFieldsOptions", field.options, error

			if Meteor.isServer

				optionsFunction = field.optionsFunction
				reference_to = field.reference_to

				if optionsFunction && _.isFunction(optionsFunction)
					field._optionsFunction = optionsFunction.toString()

				if reference_to && _.isFunction(reference_to)
					field._reference_to = reference_to.toString()
			else

				optionsFunction = field._optionsFunction
				reference_to = field._reference_to

				if optionsFunction && _.isString(optionsFunction)
					field.optionsFunction = Creator.eval("(#{optionsFunction})")

				if reference_to && _.isString(reference_to)
					field.reference_to = Creator.eval("(#{reference_to})")


