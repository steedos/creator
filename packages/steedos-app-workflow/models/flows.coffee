db.flows = new Meteor.Collection('flows')

db.flows._simpleSchema = new SimpleSchema

if Meteor.isServer
	db.flows.copy = (userId, spaceId, flowId, newFlowName, enabled)->

		flow = db.flows.findOne({_id: flowId, space: spaceId}, {fields: {_id: 1, name: 1, form: 1}})

		if !flow
			throw Meteor.Error("[flow.copy]未找到flow, space: #{spaceId}, flowId: #{flowId}");

		if newFlowName
			newName = newFlowName
		else
			newName = "复制:" + flow.name

		form = steedosExport.form(flow.form, flow._id, true)

		if _.isEmpty(form)
			throw Meteor.Error("[flow.copy]未找到form, formId: #{flow.form}");

		form.name = newName

		form.flows?.forEach (f)->
			f.name = newName

		steedosImport.workflow(userId, spaceId, form, enabled)

Creator.Objects.flows =
	name: "flows"
	icon: "timesheet"
	label: "流程"
	fields:
		name:
			type: "text"
			label:"流程名"
			required: true
			searchable: true
			readonly: true
		form:
			label:"流程表单"
			type: "lookup"
			reference_to: "forms"
			readonly: true
		category:
			label: '流程分类'
			type: "lookup"
			reference_to: "categories"
		state:
			label:"流程状态"
			type: "select"
			options: [{label: "启用",value: "enabled"},{label: "停用",value: "disabled"}]
			readonly: true
		is_valid:
			label:"流程有效"
			type: "boolean"
			readonly: true
		current_no:
			label:"当前序号"
			type: "number"
			readonly: true
		description:
			label:"备注"
			type: "textarea"
			is_wide: true
		help_text:
			label:"帮助文本"
			type: "textarea"
			is_wide: true
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
		created_by:
			label:"创建人"
		modified_by:
			label:"修改人"
		current:
#			blackbox: true
#			omit: true
#			hidden: true
			label:"步骤"
			type: 'Object'
			is_wide: true
#		'current._id':
#			type: 'text'
#			readonly: true
#			omit: true
#			hidden: true
#		'current._rev':
#			label: '版本号'
#			type: 'text'
#			readonly: true
#		'current.flow':
#			type: 'text'
#			readonly: true
#			omit: true
#			hidden: true
#		'current.form_version':
#			type: 'text'
#			readonly: true
#			omit: true
#			hidden: true
		'current.modified':
			label: "修改时间"
			type: 'datetime'
			readonly: true
			omit: true
			hidden: true
		'current.modified_by':
			label: "修改人"
			type: "lookup"
			reference_to: "users"
			readonly: true
			omit: true
			extra_field: 'current.modified'
		'current.created':
			label: "创建时间"
			type: 'datetime'
			readonly: true
			omit: true
			hidden: true
		'current.created_by':
			label: "创建人"
			type: "lookup"
			reference_to: "users"
			readonly: true
			omit: true
			extra_field: 'current.created'
		'current.steps':
			label: "步骤"
			type: "grid"
			readonly: true
			is_wide: true
		'current.steps.$._id':
			type: "text"
			omit: true
			readonly: true
			hidden: true
		'current.steps.$.name':
			label: "名称"
			readonly: true
			type: "text"
		'current.steps.$.disableCC':
			label: "禁止传阅"
			type: "boolean"
			readonly: true
		'current.steps.$.allowDistribute':
			label: "允许分发"
			type: "boolean"
			readonly: true
		'current.steps.$.can_edit_main_attach':
			label: "允许修改正文"
			type: "boolean"
			readonly: true
		'current.steps.$.can_edit_normal_attach':
			label: "允许修改附件"
			type: "boolean"
			readonly: true
#		'current.steps.$.distribute_optional_flows':
#			label: "此步骤分发时可选的流程范围"
#			type: "lookup"
#			reference_to: "flows"
#			multiple: true
		'current.steps.$.cc_must_finished':
			label: "必须等待传阅完成"
			type: "boolean"
			readonly: true
		'current.steps.$.cc_alert':
			label: "弹出传阅提醒"
			type: "boolean"
			readonly: true
		'current.steps.$.allowBatch':
			label: "批量审批"
			type: "boolean"
			readonly: true
		'current.steps.$.oneClickApproval':
			label: "一键核准"
			type: "boolean"
			readonly: true
		'current.steps.$.oneClickRejection':
			label: "一键驳回"
			type: "boolean"
			readonly: true

		perms:
			label:"权限"
			type: 'Object'
			is_wide: true

		"perms.users_can_add":
			label:"授权用户: 新建申请单"
			type: "lookup"
			reference_to: "users"
			multiple: true
			filter_by_company: true
			is_wide: true
		"perms.orgs_can_add":
			label:"授权部门: 新建申请单"
			type: "lookup"
			reference_to: "organizations"
			multiple: true
			filter_by_company: true
			is_wide: true

		"perms.users_can_monitor":
			label:"授权用户: 查看所有申请单"
			type: "lookup"
			reference_to: "users"
			multiple: true
			filter_by_company: true
			is_wide: true
		"perms.orgs_can_monitor":
			label:"授权部门: 查看所有申请单"
			type: "lookup"
			reference_to: "organizations"
			multiple: true
			filter_by_company: true
			is_wide: true

		"perms.users_can_admin":
			label:"授权用户: 查看所有申请单，并能执行重定位、转签核、删除操作"
			type: "lookup"
			reference_to: "users"
			multiple: true
			filter_by_company: true
			is_wide: true
		"perms.orgs_can_admin":
			label:"授权部门: 查看所有申请单，并能执行重定位、转签核、删除操作"
			type: "lookup"
			reference_to: "organizations"
			multiple: true
			filter_by_company: true
			is_wide: true

		app:
			label:"所属应用"
			type: "text"
			omit: true
			hidden: true
		historys:
			label:"历史版本"
			blackbox: true
			omit: true
			hidden: true
		instance_template:
			label:"表单模板"
			type: "code",
			language: "handlebars",
			is_wide: true
			rows: 6
			group: "模板"
		print_template:
			label:"打印模板"
			type: "code",
			language: "handlebars",
			rows: 6
			is_wide: true
			group: "模板"
		field_map:
			label:"映射关系"
			type: "textarea"
			rows: 6
			is_wide: true
			group: "归档"
		events:
			label:"相关事件"
			type: "textarea"
			rows: 6
			is_wide: true
			group: "脚本"
		distribute_optional_users:
			type: "lookup"
			label: "分发者"
			reference_to: "users"
			multiple: true
			is_wide: true
			group: "分发"
			filter_by_company: true
		distribute_to_self:
			label:"分发给自己"
			type: "boolean"
			group: "分发"

		name_formula:
			label:"标题公式"
			type: "text"
			group: "高级"
		code_formula:
			label:"系统公式"
			type: "text"
			group: "高级"
		auto_remind:
			label:"自动催办"
			type: "boolean"
			group: "高级"
	list_views:
		# enabled:
		# 	label: "已启用"
		# 	filter_scope: "space"
		# 	filters: [["is_deleted", "=", false], ["state", "=", "enabled"]]
		# disabled:
		# 	label: "已停用"
		# 	filter_scope: "space"
		# 	filters: [["is_deleted", "=", false], ["state", "=", "disabled"]]
		all:
			label: "所有"
			filter_scope: "space"
#			extra_columns: ["instance_template", "print_template", "field_map", "events", "distribute_optional_users", "perms"]
			columns: ["name", "modified", "modified_by", "auto_remind", "state", "is_deleted", "company_id", "form"]
		company:
			filter_scope: "company"
			columns: ["name", "modified", "modified_by", "auto_remind", "state", "is_deleted", "company_id", "form"]
			label: "本单位"

	actions:
		# standard_query:
		# 	label: "查找"
		# 	visible: false
		# 	on: "list"
		# 	todo: "standard_query"

		standard_new:
			label: "新建"
			visible: ()->
				permissions = Creator.getPermissions()
				if permissions
					return permissions["allowCreate"]
			on: "list"
			todo: (object_name, record_id, fields)->
				Modal.show('new_flow_modal')
		design:
			label: "流程设计器"
			visible: ()->
				return true;
			on: "list"
			todo: (object_name, record_id, fields)->
				Workflow.openFlowDesign(Steedos.locale(), Steedos.spaceId(), null, Creator.getUserCompanyId())
		standard_edit:
			visible: false
			on: "record"
		standard_delete:
			visible: false
			on: "record_more"
		# edit_template:
		# 	label: "设置模板"
		# 	visible: (object_name, record_id, record_permissions)->
		# 		if FlowRouter.current().params?.record_id
		# 			return true && record_permissions["allowEdit"]
		# 		return false
		# 	on: "record"
		# 	todo: (object_name, record_id, fields)->
		# 		Session.set 'cmDoc', Creator.getCollection(object_name).findOne(record_id)
		# 		Session.set 'action_fields', 'instance_template,print_template'
		# 		Meteor.defer ()->
		# 			$(".creator-edit").click()
		# edit_perms:
		# 	label: "设置权限"
		# 	visible: (object_name, record_id, record_permissions)->
		# 		if FlowRouter.current().params?.record_id
		# 			return true && record_permissions["allowEdit"]
		# 		return false
		# 	on: "record"
		# 	todo: (object_name, record_id, fields)->
		# 		console.log('edit_perms', object_name, record_id)
		# 		Session.set 'cmDoc', Creator.getCollection(object_name).findOne(record_id)
		# 		Session.set 'action_fields', 'perms, perms.orgs_can_add, perms.users_can_add, perms.orgs_can_monitor, perms.users_can_monitor, perms.orgs_can_admin, perms.users_can_admin'
		# 		Meteor.defer ()->
		# 			$(".creator-edit").click()

		# edit_events:
		# 	label: "设置脚本"
		# 	visible: (object_name, record_id, record_permissions)->
		# 		if FlowRouter.current().params?.record_id
		# 			return true && record_permissions["allowEdit"]
		# 		return false
		# 	on: "record"
		# 	todo: (object_name, record_id, fields)->
		# 		Session.set 'cmDoc', Creator.getCollection(object_name).findOne(record_id)
		# 		Session.set 'action_fields', 'events'
		# 		Meteor.defer ()->
		# 			$(".creator-edit").click()

		# edit_field_map:
		# 	label: "设置归档关系"
		# 	visible: (object_name, record_id, record_permissions)->
		# 		if FlowRouter.current().params?.record_id
		# 			return true && record_permissions["allowEdit"]
		# 		return false
		# 	on: "record"
		# 	todo: (object_name, record_id, fields)->
		# 		Session.set 'cmDoc', Creator.getCollection(object_name).findOne(record_id)
		# 		Session.set 'action_fields', 'field_map'
		# 		Meteor.defer ()->
		# 			$(".creator-edit").click()
		# edit_distribute:
		# 	label: "设置分发"
		# 	visible: (object_name, record_id, record_permissions)->
		# 		if FlowRouter.current().params?.record_id
		# 			return true && record_permissions["allowEdit"]
		# 		return false
		# 	on: "record"
		# 	todo: (object_name, record_id, fields)->
		# 		Session.set 'cmDoc', Creator.getCollection(object_name).findOne(record_id)
		# 		Session.set 'action_fields', 'distribute_optional_users,distribute_to_self'
		# 		Meteor.defer ()->
		# 			$(".creator-edit").click()

		designFlow:
			label: "流程设计器"
			visible: (object_name, record_id, record_permissions)->
				return true;
			on: "record"
			todo: (object_name, record_id, fields)->
				Workflow.openFlowDesign(Steedos.locale(), Steedos.spaceId(), record_id, Creator.getUserCompanyId())

#		edit_steps:
#			label: "设置步骤"
#			visible: (object_name, record_id, record_permissions)->
#				if FlowRouter.current().params?.record_id
#					return true && record_permissions["allowEdit"]
#				return false
#			on: "record"
#			todo: (object_name, record_id, fields)->
#				console.log('edit_steps', object_name, record_id)
#				Session.set 'cmDoc', Creator.getCollection(object_name).findOne(record_id)
#				Session.set 'action_fields', 'current,current._rev,current.steps'
#				Meteor.defer ()->
#					$(".creator-edit").click()
		exportFlow:
			label: "导出流程"
			visible: true
			on: "record"
			todo: (object_name, record_id, fields)->
				console.log("exportFlow", object_name, record_id, fields);
				if this.record?.form?._id
					window.open("/api/workflow/export/form?form=#{this.record.form._id}", '_blank')
				else
					flow = Creator.getCollection(object_name).findOne(record_id)
					if flow
						window.open("/api/workflow/export/form?form=#{flow.form}", '_blank')
		importFlow:
			label: "导入流程"
			visible: true
			on: "list"
			todo: ()->
				Modal.show "admin_import_flow_modal", {
					onSuccess: (flows)->
						if flows.length > 0
							FlowRouter.go("/app/admin/flows/view/#{flows[0]}")
				}
		copyFlow:
			label: "复制流程"
			visible: true
			on: "record"
			todo: (object_name, record_id, fields)->
				swal {
					title: t("workflow_copy_flow"),
					text: t("workflow_copy_flow_text"),
					type: "input",
					confirmButtonText: t('OK'),
					cancelButtonText: t('Cancel'),
					showCancelButton: true,
					closeOnConfirm: false
				}, (reason) ->
					if (reason == false)
						return false;

					if (reason == "")
						swal.showInputError(t("workflow_copy_flow_error_reason_required"));
						return false;

					Meteor.call "flow_copy", Steedos.spaceId(), record_id, reason, (error, result)->
						if error
							toastr.error 'error'
						else
							toastr.success t('workflow_copy_flow_success')
							sweetAlert.close();
							if result.length > 0
								FlowRouter.go("/app/admin/flows/view/#{result[0]}")

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
			allowDelete: false
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
	db.flows._simpleSchema.i18n("flows")

db.flows.attachSchema(db.flows._simpleSchema)

if Meteor.isServer

	db.flows.before.insert (userId, doc) ->
		if not userId
			return

		doc.created_by = userId
		doc.created = new Date()

	db.flows.after.update (userId, doc, fieldNames, modifier, options) ->
		if doc.category != this.previous.category
			if doc.category
				db.forms.update(doc.form, { $set: { category: doc.category } })
			else
				db.forms.update(doc.form, { $unset: { category: 1 } })
		
		if doc.company_id != this.previous.company_id
			if doc.company_id
				db.forms.update(doc.form, { $set: { company_id: doc.company_id } })
			else
				db.forms.update(doc.form, { $unset: { company_id: 1 } })