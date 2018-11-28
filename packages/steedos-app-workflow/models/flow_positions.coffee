db.flow_positions = new Meteor.Collection('flow_positions')

db.flow_positions._simpleSchema = new SimpleSchema

Creator.Objects.flow_positions =
	name: "flow_positions"
	icon: "metrics"
	label: "岗位成员"
	fields:
		role:
			type: "master_detail"
			label: "岗位"
			reference_to: "flow_roles"
			required: true

		users:
			type: "lookup"
			label: "成员"
			reference_to: "users"
			multiple: true
			required: true
			beforeOpenFunction: (event, template)->
				company_id = Creator.odata.get("flow_roles", AutoForm.getFormValues().insertDoc.role, "company_id")?.company_id
				if company_id
					event.currentTarget.dataset.rootOrg = company_id

		org:
			type: "lookup"
			label: "管辖范围"
			reference_to: "organizations"
			required: true
			is_name: true

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
			columns: ["org","users"]
			label: "所有"

		company:
			filter_scope: "company"
			columns: ["org","users"]
			label: "公司级"

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
	db.flow_positions._simpleSchema.i18n("flow_positions")

db.flow_positions.attachSchema db.flow_positions._simpleSchema

if Meteor.isServer

	db.flow_positions.allow
		insert: (userId, event) ->
			if (!Steedos.isSpaceAdmin(event.space, userId))
				return false
			else
				return true

		update: (userId, event) ->
			if (!Steedos.isSpaceAdmin(event.space, userId))
				return false
			else
				return true

		remove: (userId, event) ->
			if (!Steedos.isSpaceAdmin(event.space, userId))
				return false
			else
				return true

	db.flow_positions.before.insert (userId, doc) ->

		doc.created_by = userId;
		doc.created = new Date();

	db.flow_positions.before.update (userId, doc, fieldNames, modifier, options) ->

		modifier.$set = modifier.$set || {};

		modifier.$set.modified_by = userId;
		modifier.$set.modified = new Date();

	db.flow_positions.before.insert (userId, doc) ->
		if not userId
			return

		doc.created_by = userId
		doc.created = new Date()
		doc.modified_by = userId
		doc.modified = new Date()

		su = db.space_users.findOne({space: doc.space, user: userId}, {fields: {company_id: 1}})
		if su && su.company_id
			doc.company_id = su.company_id