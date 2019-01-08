db.instances = new Meteor.Collection('instances')

Creator.Objects.instances =
	name: "instances"
	icon: "task"
	label: "申请单"
	fields:
		name:
			label:"文件标题"
			type: "text"
			defaultValue: ""
			description: ""
			inlineHelpText: ""
			required: true
			searchable:true
			is_wide: true
			#index:true
		flow:
			label:"流程"
			type: "lookup"
			reference_to: "flows"
			readonly: true
		flow_version:
			label:"流程版本号"
			type: "string"
			hidden: true
		form:
			label:"表单"
			type: "lookup"
			reference_to: "forms"
			readonly: true
		form_version:
			label:"表单版本号"
			type: "string"
			hidden: true
		submitter:
			label:"提交者"
			type: "master_detail"
			reference_to: "users"
			readonly: true
		submitter_name:
			type: "string"
			label:"提交者"
			hidden: true
		submit_date:
			type: "datetime"
			label:"提交日期"
		applicant:
			type: "lookup"
			label:"申请人"
			reference_to: "users"
		applicant_name:
			type: "string"
			label:"申请人"
			hidden: true
		applicant_organization:
			type: "lookup"
			label:"申请人部门"
			reference_to: "organizations"
		applicant_organization_name:
			type: "string"
			label:"申请人部门名称"
			hidden: true
		applicant_organization_fullname:
			type: "string"
			label:"申请人部门全称"
			hidden: true
		code:
			label:"公式"
			type: "string"
			hidden: true
		values:
			blackbox: true
			omit: true
			label:"申请单内容"
			hidden: true
		inbox_users:
			type: "string"
			type: "lookup"
			multiple: true
			reference_to: "users"
			label:"待办处理人"
		outbox_users:
			type: "string"
			type: "lookup"
			multiple: true
			reference_to: "users"
			label:"已办处理人"
		traces:
			type: [Object]
			blackbox: true
			omit: true
			label:"步骤审批"
			hidden: true
		attachments:
			type: [Object]
			blackbox: true
			omit: true
			label:"附件"
			hidden: true
		flow_name:
			type: "string"
			label:"流程名"
			hidden: true
		category_name:
			type: "string"
			label:"流程分类"
			hidden: true
		state:
			type: "string"
			label:"申请单状态"

		is_recorded:
			type: "boolean"
			label:"已归档"
		is_archived:
			type: "boolean"
			label:"已归档(旧)"
			hidden: true
		is_deleted:
			type: "boolean"
			label:"已删除"
			hidden: true

		related_instances:
			type: "string"
			type: "lookup"
			multiple: true
			reference_to: "instances"
			label:"相关申请单"
			is_wide: true

		record_ids:
			label:"记录ID"
			type: "grid"
			omit: true
			hidden: true

		"record_ids.$.o":
			type: "text"
			hidden:true
		"record_ids.$.ids":
			type: "[text]"
			hidden:true

		company_id:
			label: "所属单位"
			type: "lookup"
			reference_to: "organizations"
			sortable: true
			index:true
			is_company_only: true
			required: Meteor.settings?.public?.is_group_company
			defaultValue: ()->
				if Meteor.isClient
					return Session.get("user_company_id")

	list_views:
		all:
			label:'所有'
			filter_scope: "space"
			columns: ["name", "applicant", "applicant_organization", "modified", "state"]
		inbox:
			label: "待办文件"
			filter_scope: "space"
			filters: [["inbox_users", "=", "{userId}"]]
		outbox:
			label: "已办文件"
			filter_scope: "space"
			filters: [["outbox_users", "=", "{userId}"]]

	permission_set:
		user:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: false
		admin:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true
		workflow_admin:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: false
			modifyCompanyRecords: false
			viewCompanyRecords: true
			disabled_list_views: ['inbox','outbox']
			disabled_actions: []
			unreadable_fields: []
			uneditable_fields: []
			unrelated_objects: []

	actions:
		view_instance:
			label: "查看申请单"
			visible: true
			on: "record"
			todo: (object_name, record_id, fields)->
				uobj = {}
				uobj["box"] = 'monitor'
				uobj["X-User-Id"] = Meteor.userId()
				uobj["X-Auth-Token"] = Accounts._storedLoginToken()
				workflowUrl = window.location.protocol + '//' + window.location.hostname + '/'
				Steedos.openWindow(workflowUrl + "workflow/space/" + Session.get("spaceId") + "/print/" + record_id + "?" + $.param(uobj), "",'width=900,height=750,scrollbars=yes,EnableViewPortScale=yes,toolbarposition=top,transitionstyle=fliphorizontal,menubar=yes,closebuttoncaption=  x  ')

if Meteor.isServer
	db.instances.allow

		insert: (userId, event) ->
			return false

		update: (userId, event) ->
			if event.state == "draft" && (event.applicant == userId || event.submitter == userId)
				return true
			else
				return false

		remove: (userId, event) ->
			return false

	Meteor.methods
		getRelatedInstancesOptions: (options)->
			uid = this.userId;
			searchText = options.searchText;
			values = options.values;
			instanceId = options.params

			selectedOPtions = []

#			Meteor.wrapAsync((callback) ->
#				Meteor.setTimeout (->
#					callback()
#					return
#				), 1000
#				return
#			)()

			options = new Array();

			instances = new Array();

			if instanceId
				instance = db.instances.findOne(instanceId, { fields: { related_instances: 1 } })
				if instance
					selectedOPtions = instance.related_instances

			if searchText
				pinyin = /^[a-zA-Z\']*$/.test(searchText)
				if (pinyin && searchText.length > 8) || (!pinyin && searchText.length > 1)
#					console.log "searchText is #{searchText}"
					query = {state: {$in: ["pending", "completed"]}, name: {$regex: searchText},$or: [{submitter: uid}, {applicant: uid}, {inbox_users: uid}, {outbox_users: uid}, {cc_users: uid}]}

					if selectedOPtions && _.isArray(selectedOPtions)
						query._id = {$nin: selectedOPtions}

					instances = db.instances.find(query, {limit: 10, fields: {name: 1, flow: 1, applicant_name: 1}}).fetch()

			else if values.length
				instances = db.instances.find({_id: {$in: values}}, {fields: {name: 1, flow: 1, applicant_name: 1}}).fetch();


			instances.forEach (instance)->
				flow = db.flows.findOne({_id: instance.flow}, {fields: {name: 1}});
				options.push({label: "[" + flow?.name + "]" + instance.name + ", "+ instance.applicant_name, value: instance._id});

			return options;

	# 全文检索同步字段置位unset
	db.instances.before.update (userId, doc, fieldNames, modifier, options) ->
		modifier.$unset = modifier.$unset || {};
		modifier.$unset.is_recorded = 1;

	if Meteor.settings.cron?.instancerecordqueue_interval
		db.instances.after.update (userId, doc, fieldNames, modifier, options) ->
			if doc.state is 'completed'
				uuflowManager.triggerRecordInstanceQueue doc._id, doc.record_ids, doc.current_step_name


	db.instances._ensureIndex({
		"space": 1
	},{background: true})

	db.instances._ensureIndex({
		"is_deleted": 1
	},{background: true})

	db.instances._ensureIndex({
		"submitter": 1
	},{background: true})

	db.instances._ensureIndex({
		"applicant": 1
	},{background: true})

	db.instances._ensureIndex({
		"outbox_users": 1
	},{background: true})

	db.instances._ensureIndex({
		"inbox_users": 1
	},{background: true})

	db.instances._ensureIndex({
		"space": 1,
		"is_deleted": 1
	},{background: true})

	db.instances._ensureIndex({
		"state": 1
	},{background: true})

	db.instances._ensureIndex({
		"is_archived": 1
	},{background: true})

	db.instances._ensureIndex({
		"created": 1
	},{background: true})

	db.instances._ensureIndex({
		"_id": 1,
		"submit_date": 1
	},{background: true})

	db.instances._ensureIndex({
		"space": 1,
		"flow": 1,
		"state": 1,
		"submit_date": 1
	},{background: true})

	db.instances._ensureIndex({
		"created": 1,
		"modified": 1
	},{background: true})

	db.instances._ensureIndex({
		"is_deleted": 1,
		"state": 1,
		"space": 1,
		"final_decision": 1,
		"submitter": 1,
		"applicant": 1
	},{background: true})

	db.instances._ensureIndex({
		"is_deleted": 1,
		"space": 1,
		"modified": 1,
		"outbox_users": 1
	},{background: true})

	db.instances._ensureIndex({
		"is_deleted": 1,
		"state": 1,
		"space": 1,
		"modified": 1,
		"final_decision": 1,
		"submitter": 1,
		"applicant": 1
	},{background: true})

	db.instances._ensureIndex({
		"is_deleted": 1,
		"space": 1,
		"outbox_users": 1
	},{background: true})

	db.instances._ensureIndex({
		"is_deleted": 1,
		"space": 1,
		"modified": 1,
		"submit_date": 1,
		"outbox_users": 1
	},{background: true})

	db.instances._ensureIndex({
		"is_deleted": 1,
		"space": 1,
		"submit_date": 1,
		"outbox_users": 1
	},{background: true})

	db.instances._ensureIndex({
		"is_deleted": 1,
		"state": 1,
		"space": 1,
		"flow": 1,
		"modified": 1
	},{background: true})

	db.instances._ensureIndex({
		"is_deleted": 1,
		"state": 1,
		"space": 1,
		"flow": 1
	},{background: true})

	db.instances._ensureIndex({
		"is_deleted": 1,
		"state": 1,
		"space": 1,
		"flow": 1,
		"submit_date": 1,
		"modified": 1
	},{background: true})

	db.instances._ensureIndex({
		"is_deleted": 1,
		"state": 1,
		"space": 1,
		"flow": 1,
		"submit_date": 1
	},{background: true})

	db.instances._ensureIndex({
		"is_deleted": 1,
		"state": 1,
		"space": 1,
		"submitter": 1,
		"applicant": 1,
		"inbox_users": 1
	},{background: true})

	db.instances._ensureIndex({
		"is_deleted": 1,
		"state": 1,
		"space": 1,
		"is_archive": 1,
		"submitter": 1,
		"applicant": 1
	},{background: true})

	db.instances._ensureIndex({
		"modified": 1
	},{background: true})

	db.instances._ensureIndex({
		"modified": 1
	},{background: true})

	db.instances._ensureIndex({
		"cc_users": 1
	},{background: true})

	db.instances._ensureIndex({
		"space": 1,
		"state": 1,
		"is_deleted": 1
	},{background: true})

	db.instances._ensureIndex({
		"keywords": "hashed",
	},{background: true})

	db.instances._ensureIndex({
		"space": 1,
		"submit_date": 1,
		"is_deleted": 1,
		"final_decision": 1,
		"state": 1
	},{background: true})

	db.instances._ensureIndex({
		"traces.approves.type": 1,
		"traces.approves.handler": 1
	},{background: true})

	# 全文检索同步字段
	db.instances._ensureIndex({
		"is_recorded": 1
	},{background: true})