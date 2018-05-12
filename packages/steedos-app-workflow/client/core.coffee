Meteor.startup ()->
	Session.set("isCreator", true)
	Session.set("instance_details_url", "/app/workflow/instances/view/")
	Meteor.autorun ()->
		if Session.get("box")
			Session.set("instance_list_url", "/app/workflow/instances/grid/#{Session.get("box")}")