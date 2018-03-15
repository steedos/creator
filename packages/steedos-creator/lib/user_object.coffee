
Creator.getUserObjectsListViews = (userId, spaceId, objects)->

	listViews = {}

	_.forEach objects, (o, key)->
		listViews[key] = Creator.getUserObjectListViews userId, spaceId, key

	return listViews


Creator.getUserObjectListViews = (userId, spaceId, object_name)->

	_user_object_list_views = {}

	console.log userId, spaceId, object_name

	object_listview = Creator.getCollection("object_listviews").find({object_name: object_name, space: spaceId ,"$or":[{owner: userId}, {shared: true}]})

	object_listview.forEach (listview)->
		if listview.is_default
			_user_object_list_views.all = listview
		else
			_user_object_list_views[listview._id] = listview

	return _user_object_list_views




