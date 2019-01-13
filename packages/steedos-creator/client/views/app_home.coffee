#Template.creator_app_home.onRendered ()->
#	if Session.get("app_id")
#		first_app_obj = _.first(Creator.getApp(Session.get("app_id")).objects)
#		FlowRouter.go Creator.getObjectUrl(first_app_obj, null, Session.get("app_id"))