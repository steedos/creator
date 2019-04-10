steedosCord = require('@steedos/core')
steedosCord.getObjectConfigManager().loadStandardObjects()
# Creator.Objects = steedosCord.Objects
# Creator.Reports = steedosCord.Reports
Meteor.startup ->
	try
		objectql = require("@steedos/objectql")
		newObjects = {}
		objectsRolesPermission = {}
		_.each Creator.Objects, (obj, key)->
			if /^[_a-zA-Z][_a-zA-Z0-9]*$/.test(key)
				newObjects[key] = obj
			objectsRolesPermission[key] = obj.permission_set

		Creator.steedosSchema = new objectql.SteedosSchema({
			datasources: {
				default: {
					driver: 'meteor-mongo'
					objects: newObjects
					objectsRolesPermission: objectsRolesPermission
				}
			}
			getRoles: (userId)->
				# TODO 获取用户角色
				return ['admin']
		})
	catch e
		console.error(e)
