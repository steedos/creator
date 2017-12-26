Meteor.methods
	# Calculate Permissions on Server
	"creator.object_permissions": (spaceId)->
		object_permissions = {}
		_.each Creator.objectsByName, (object, object_name)->
			if Creator.isSpaceAdmin(spaceId, this.userId)
				object_permissions[object_name] = object.permission_set.admin
			else
				object_permissions[object_name] = object.permission_set.user
		return object_permissions
