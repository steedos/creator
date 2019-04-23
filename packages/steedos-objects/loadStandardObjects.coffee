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
		router = express.Router();
		router.use((req, res, next)->
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
###
		Creator.steedosSchema.addDataSource('sqlite', {
			driver: "sqlite",
			url: "E:/database/sqlite/test.db",
			objects: {
				test: {
					label: 'Sqlite3 Schema',
					icon: 'event',
					enable_search: true,
					fields: {
						id: {
							label: '主键',
							type: 'number',
							primary: true,
							generated: true
							is_name: true
						},
						text: {
							label: '文本',
							type: 'text'
						},
						textarea: {
							label: '长文本',
							type: 'textarea'
						},
						int: {
							label: '数量',
							type: 'number'
						},
						double: {
							label: '双精度数值',
							type: 'number',
							scale: 4
						},
						date: {
							label: '日期',
							type: 'date'
						},
						datetime: {
							label: '创建时间',
							type: 'datetime'
						}
					},
					permission_set: {
						admin: {
							allowCreate: true,
							allowDelete: true,
							allowEdit: true,
							allowRead: true,
							modifyAllRecords: true,
							viewAllRecords: true
						}
					},

					list_views: {
						all: {
							label: '全部',
							filter_scope: "space",
							columns: ['id','text','textarea','int','double','date','datetime']
						}
					}
				}
			}
		})

		Creator.steedosSchema.addApp('sqlite', {
			icon_slds: "timesheet"
			objects: ["sqlite.test"]
		})

		createTables = Meteor.wrapAsync (cb)->
			Creator.steedosSchema.getDataSource('sqlite').createTables().then (resolve, reject)->
				cb(reject, resolve)

		createTables()
###
		_.each Creator.steedosSchema.getDataSources(), (datasource, name) ->
			router.use("/#{name}", graphqlHTTP({
				schema: datasource.buildGraphQLSchema(),
				graphiql: true
			}))

		app.use('/graphql', router);
		WebApp.connectHandlers.use(app);
	catch e
		console.error(e)
