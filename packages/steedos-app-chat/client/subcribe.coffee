Meteor.startup ->
	Tracker.autorun (c)->
		if Meteor.userId()
			options =
				sort: {'created': -1}
				limit: 50
				fields: {
					_id: 1,
					space: 1,
					owner: 1,
					created: 1,
					related_to: 1,
					name: 1,
#					type: 1
				}
			Meteor.subscribe "chat_messages", Session.get("spaceId"), Session.get("object_name"), Session.get("record_id"), options