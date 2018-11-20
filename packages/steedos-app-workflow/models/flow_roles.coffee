db.flow_roles = new Meteor.Collection('flow_roles')

db.flow_roles._simpleSchema = new SimpleSchema

Creator.Objects.flow_roles =
	name: "flow_roles"
	icon: "metrics"
	label: "审批岗位"
	fields:
		name:
			type: "text"
			label: "名称"

		company_id:
			label: "所属公司"
			type: "lookup"
			reference_to: "organizations"
			sortable: true
			index:true
			omit: true
			hidden: true

	list_views:
		all:
			filter_scope: "space"
			columns: ["name"]
			label: "所有"

	permission_set:
		user:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true
		admin:
			allowCreate: true
			allowDelete: true
			allowEdit: true
			allowRead: true
			modifyAllRecords: true
			viewAllRecords: true

if Meteor.isClient
	db.flow_roles._simpleSchema.i18n("flow_roles")

db.flow_roles.attachSchema db.flow_roles._simpleSchema

if Meteor.isServer

	db.flow_roles.before.insert (userId, doc) ->
		if not userId
			return

		doc.created_by = userId
		doc.created = new Date()
		doc.modified_by = userId
		doc.modified = new Date()

		su = db.space_users.findOne({space: doc.space, user: userId}, {fields: {company_id: 1}})
		if su && su.company_id
			doc.company_id = su.company_id

