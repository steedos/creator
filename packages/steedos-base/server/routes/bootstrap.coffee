JsonRoutes.add "get", "/api/bootstrap/:spaceId/",(req, res, next)->
	userId = req.headers['x-user-id']
	spaceId = req.headers['x-space-id'] || req.params?.spaceId
	if !userId
		JsonRoutes.sendResult res,
			code: 403,
			data: null
		return

	USER_CONTEXT = Creator.getUserContext(userId, spaceId, true)
	unless USER_CONTEXT
		JsonRoutes.sendResult res,
			code: 500,
			data: null
		return
	
	space = Creator.Collections["spaces"].findOne({_id: spaceId}, {fields: {name: 1}})

	result = Creator.getAllPermissions(spaceId, userId)
	result.USER_CONTEXT = USER_CONTEXT
	result.space = space
	result.apps = _.extend Creator.getDBApps(spaceId), Creator.Apps
	result.object_listviews = Creator.getUserObjectsListViews(userId, spaceId, result.objects)
	result.object_workflows = Meteor.call 'object_workflows.get', spaceId, userId

	permissions = Meteor.wrapAsync (v, userId, cb)->
		v.getUserObjectPermission(userId).then (resolve, reject)->
			cb(reject, resolve)

	_.each Creator.steedosSchema.getDataSources(), (datasource, name) ->
		if name != 'default'
			datasourceObjects = datasource.getObjects()
			_.each(datasourceObjects, (v, k)->
				_obj = v.toConfig()
				_obj.name = "#{name}.#{k}"
				_obj.database_name = name
				_obj.permissions = permissions(v, userId)
				result.objects[_obj.name] = _obj
			)

	result.apps = _.extend result.apps, Creator.steedosSchema.getAppsConfig()

	JsonRoutes.sendResult res,
		code: 200,
		data: result
