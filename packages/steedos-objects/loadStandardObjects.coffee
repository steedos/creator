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

		express = require('express');
		graphqlHTTP = require('express-graphql');
		Cookies = require("cookies");
		app = express();
		app.use((req, res, next)->
			cookies = new Cookies(req, res)
			userId = req.headers['x-user-id'] || cookies.get("X-User-Id")
			authToken = req.headers['x-auth-token'] || cookies.get("X-Auth-Token")
			user = null
			if userId and authToken
				searchQuery = {}
				searchQuery['services.resume.loginTokens.hashedToken'] = Accounts._hashLoginToken authToken
				user = Meteor.users.findOne
					'_id': userId
					searchQuery

			if user
				next();
			else
				res.status(401).send({ errors: [{ 'message': 'You must be logged in to do this.' }] });
		)

		_.each Creator.steedosSchema.getDataSources(), (datasource, name) ->
			app.use("/graphql/#{name}", graphqlHTTP({
				schema: datasource.buildGraphQLSchema(),
				graphiql: true
			}))

		WebApp.connectHandlers.use(app);
	catch e
		console.error(e)
