Meteor.startup ()->
	Creator.convertTODOToFunction = (object)->
		_.forEach object.triggers, (trigger, key)->
			_todo = trigger.todo
			if _todo && _.isString(_todo)
				#只有update时， fieldNames, modifier, options 才有值
				trigger.todo = (userId, doc, fieldNames, modifier, options)->
					#TODO 控制可使用的变量，尤其是Collection
					Creator.evalInContext(_todo, this)

		if Meteor.isClient
			_.forEach object.actions, (action, key)->
				_todo = action?.todo
				if _todo && _.isString(_todo)
					action.todo = ()->
						#TODO 控制可使用的变量
						Creator.evalInContext(_todo, this)