db.forms = new Meteor.Collection('forms')

Creator.Objects.forms =
	name: "forms"
	icon: "timesheet"
	label: "表单"
	fields:
		name:
			type: "text"
			label:"表单"
			required: true
			searchable: true
			readonly: true
		state:
			type: "select"
			label:"表单状态"
			options: [{label: "启用",value: "enabled"},{label: "停用",value: "disabled"}]
			readonly: true

		description:
			type: "textarea"
			label:"表单描述"
			is_wide: true

		category:
			type: "lookup"
			label: "表单分类"
			reference_to: "categories"
			readonly: true
		is_valid:
			type: "boolean"
			label:"是否有效"
			readonly: true

		historys:
			label:"历史版本"
			blackbox: true
			omit: true
			hidden: true

		approve_on_create:
			label:"是否同意审批"
			type: "boolean"
		approve_on_modify:
			label:"是否修改审批"
			type: "boolean"
		approve_on_delete:
			type: "boolean"
			label:"是否删除审批"
		enable_workflow:
			type: "boolean"
			label:"是否启用工作流"
		enable_view_others:
			type: "boolean"
			label:"是否查看其它表单"

		current:
			label:"当前版本"
			type: 'Object'
			is_wide: true
			readonly: true

		'current.form_script':
			label: "表单脚本"
			type: 'textarea'
			readonly: true
		'current.name_forumla':
			label: "标题公式"
			type: 'textarea'
			readonly: true

	list_views:
		all:
			label: "所有"
			filter_scope: "space"
			filters: [["is_deleted", "=", false]]
			columns: ["name", "category", "modified", "modified_by", "auto_remind", "state"]
		company:
			filter_scope: "company"
			columns: ["name"]
			label: "本单位"
	actions:
		standard_new:
			visible: false
			on: "list"
		standard_edit:
			visible: false
			on: "record"
		standard_delete:
			visible: false
			on: "record_more"

	permission_set:
		user:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true
		admin:
			allowCreate: false
			allowDelete: false
			allowEdit: true
			allowRead: true
			modifyAllRecords: true
			viewAllRecords: true
		workflow_admin:
			allowCreate: false
			allowDelete: false
			allowEdit: true
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true
			disabled_list_views: ['all']
			disabled_actions: []
			unreadable_fields: []
			uneditable_fields: []
			unrelated_objects: []

if Meteor.isServer

	db.forms.before.insert (userId, doc) ->
		if not userId
			return

		doc.created_by = userId
		doc.created = new Date()

		su = db.space_users.findOne({space: doc.space, user: userId}, {fields: {company_id: 1}})
		if su && su.company_id
			doc.company_id = su.company_id