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
			label: "所属单位"
			type: "lookup"
			reference_to: "organizations"
			sortable: true
			index:true
			is_company_only: true

	list_views:
		all:
			filter_scope: "space"
			columns: ["name", "company_id"]
			label: "所有"

		company:
			filter_scope: "company"
			columns: ["name","company_id"]
			label: "本单位"

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
		workflow_admin:
			allowCreate: true
			allowDelete: false
			allowEdit: true
			allowRead: true
			modifyAllRecords: true
			viewAllRecords: true
			disabled_list_views: ['all']
			disabled_actions: []
			unreadable_fields: []
			uneditable_fields: []
			unrelated_objects: []

if Meteor.isClient
	db.flow_roles._simpleSchema.i18n("flow_roles")

db.flow_roles.attachSchema db.flow_roles._simpleSchema

if Meteor.isServer

	db.flow_roles.allow
		insert: (userId, event) ->
			if (!Steedos.isSpaceAdmin(event.space, userId))
				return false
			else
				return true

		remove: (userId, event) ->
			if (!Steedos.isSpaceAdmin(event.space, userId))
				return false
			else
				return true

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

	db.flow_roles.before.update (userId, doc, fieldNames, modifier, options) ->

		modifier.$set = modifier.$set || {};

		modifier.$set.modified_by = userId;
		modifier.$set.modified = new Date();

	db.flow_roles.before.remove (userId, doc) ->

		if db.flow_positions.find({role: doc._id}).count()>0
			throw new Meteor.Error(400, "flow_roles_error_positions_exists");

		# 如果岗位被流程引用，应该禁止删除 #1289
		flowNames = []
		roleId = doc._id
		_.each db.flows.find({space: doc.space}, {fields: {name: 1, 'current.steps': 1}}).fetch(), (f)->
			_.each f.current.steps, (s)->
				if s.deal_type is 'applicantRole' and s.approver_roles.includes(roleId)
					flowNames.push f.name

		if not _.isEmpty(flowNames)
			throw new Meteor.Error 400, "flow_roles_error_flows_used", {names: _.uniq(flowNames).join(',')}

