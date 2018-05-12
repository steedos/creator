Creator.Objects.instances =
	name: "instances"
	icon: "task"
	label: "申请单"
	enter_details_route: ()->
		Session.set("instanceId", Session.get("record_id"))
		Session.set("instance_loading", true);
		Session.set("judge", null);
		Session.set("next_step_id", null);
		Session.set("next_step_multiple", null);
		Session.set("next_user_multiple", null);
		Session.set("box", Session.get("list_view_id"));
	exit_details_route: (params, queryParams)->
		if (Session.get("box") == "draft" || Session.get("box") == "inbox") && Session.get("instance_change") && (InstanceManager.isCC(WorkflowManager.getInstance()) || !ApproveManager.isReadOnly())
			InstanceManager.saveIns();
		Session.set("instanceId", null);
		Session.set('flow_selected_opinion', undefined);

	details_template: "instance_view"
	details_template_show: ()->
		if Steedos.subs["Instance"].ready() && Steedos.subs["instance_data"].ready()
			console.log("sub instance ready.....")
			Session.set("instance_loading", false);
			$("body").removeClass("loading")
			instance = WorkflowManager.getInstance()

			if !instance || !instance.traces
				return false;

			if instance.flow_version && instance.form_version
				flow_version = db.flow_versions.findOne({_id: instance.flow_version})

				form_version = db.form_versions.findOne({_id: instance.form_version})

				if !flow_version || !form_version
					return false;

			if instance
				if Session.get("box") == "inbox"
					if InstanceManager.isInbox()
						return true
					else if instance.state == 'draft'
						Session.set("list_view_id", "draft")
					else
						FlowRouter.go("/app/workflow/instances/grid/#{Session.get("box")}")
				else
					return true
			else # 订阅完成 instance 不存在，则认为instance 已经被删除
				FlowRouter.go("/app/workflow/instances/grid/#{Session.get("box")}")
		return false
	fields:
		name:
			label:"文件标题"
			type: "text"
			defaultValue: ""
			description: ""
			inlineHelpText: ""
			required: true
			searchable:true
			#index:true
		flow:
			label:"所属流程"
			type: "master_detail"
			reference_to: "flows"
			readonly: true
		flow_version:
			label:"流程版本"
			type: "string"
		form:
			label:"申请单表单"
			type: "master_detail"
			reference_to: "forms"
			readonly: true
		form_version:
			label:"申请单版本"
			type: "string"
		submitter:
			label:"提交者"
			type: "master_detail"
			reference_to: "users"
			readonly: true
		submitter_name:
			type: "string"
			label:"提交者"
		applicant:
			type: "lookup"
			label:"申请人"
			reference_to: "users"
		applicant_name:
			type: "string"
			label:"申请人"
		applicant_organization:
			type: "lookup"
			label:"申请单位"
			reference_to: "organizations"
		applicant_organization_name:
			type: "string"
			label:"申请单位"
		applicant_organization_fullname:
			type: "string"
			label:"申请单位全称"
		submit_date:
			type: "datetime"
			label:"提交日期"
		code:
			label:"公式"
			type: "string"
		is_archived:
			type: "boolean"
			label:"已归档"
		is_deleted:
			type: "boolean"
			label:"已删除"
		values:
			blackbox: true
			omit: true
			label:"申请单内容"
		inbox_users:
			type: [String]
			label:"待办处理人"
		outbox_users:
			type: [String]
			label:"已办处理人"
		traces:
			type: [Object]
			blackbox: true
			omit: true
			label:"步骤审批"
		attachments:
			type: [Object]
			blackbox: true
			omit: true
			label:"附件"
		flow_name:
			type: "string"
			label:"流程名"
		category_name:
			type: "string"
			label:"流程分类"
		related_instances:
			type: [String]
			label:"相关申请单"
		state:
			type: "string"
			label:"申请单状态"
		finish_date:
			type: "datetime"
			label:"结束时间"
		record_ids:
			label:"记录ID"
			type: "grid"
			omit: true

		"record_ids.$.o":
			type: "text"
			hidden:true
		"record_ids.$.ids":
			type: "[text]"
			hidden:true

	list_views:
		draft:
			label: "草稿文件"
			columns: ["name", "applicant", "applicant_organization", "modified"]
			filter_scope: "space"
			filters: [["submitter", "=", "{userId}"], ["state", "=", "draft"]]
		inbox:
			columns: ["name", "applicant", "applicant_organization", "modified"]
			label: "待办文件"
			filter_scope: "space"
			filters: [["inbox_users", "=", "{userId}"]]
		outbox:
			columns: ["name", "applicant", "applicant_organization", "modified"]
			label: "已办文件"
			filter_scope: "space"
			filters: [["outbox_users", "=", "{userId}"]]
		monitor:
			columns: ["name", "applicant", "applicant_organization", "modified"]
			label: "监控箱"
			filter_scope: "space"
			filters: [["state", "=", ["pending", "completed"]]]

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
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true

	actions:
		new_instance:
			label: "新建草稿"
			visible: ()->
				InstanceActions.new.visible()
			on: "list"
			todo: (object_name, record_id, fields)->
				InstanceActions.new.todo(object_name, record_id, fields)
		submit_instance:
			label: "发送"
			visible: ()->
				InstanceActions.submit.visible()
			on: "record"
			todo: (object_name, record_id, fields)->
				InstanceActions.submit.todo(object_name, record_id, fields)
		delete_instance:
			label: "删除"
			visible: ()->
				InstanceActions.delete.visible()
			on: "record"
			todo: (object_name, record_id, fields)->
				InstanceActions.delete.todo(object_name, record_id, fields)
		terminate_instance:
			label: "取消申请"
			visible: ()->
				InstanceActions.terminate.visible()
			on: "record"
			todo: (object_name, record_id, fields)->
				InstanceActions.terminate.todo(object_name, record_id, fields)
		reassign_instance:
			label: "转签核"
			visible: ()->
				InstanceActions.reassign.visible()
			on: "record"
			todo: (object_name, record_id, fields)->
				InstanceActions.reassign.todo(object_name, record_id, fields)
		relocate_instance:
			label: "重定位"
			visible: ()->
				InstanceActions.relocate.visible()
			on: "record"
			todo: (object_name, record_id, fields)->
				InstanceActions.relocate.todo(object_name, record_id, fields)
		cc_instance:
			label: "传阅"
			visible: ()->
				InstanceActions.cc.visible()
			on: "record"
			todo:(object_name, record_id, fields)->
				InstanceActions.cc.todo(object_name, record_id, fields)
		save_instance:
			label: "保存"
			visible: ()->
				InstanceActions.save.visible()
			on: "record"
			todo:(object_name, record_id, fields)->
				InstanceActions.save.todo(object_name, record_id, fields)
		return_instance:
			label: "退回"
			visible: ()->
				InstanceActions.return.visible()
			on: "record"
			todo:(object_name, record_id, fields)->
				InstanceActions.return.todo(object_name, record_id, fields)
		retrieve_instance:
			label: "取回"
			visible: ()->
				InstanceActions.retrieve.visible()
			on: "record"
			todo: (object_name, record_id, fields)->
				InstanceActions.retrieve.todo(object_name, record_id, fields)
		traces_instance:
			label: "签核历程"
			visible: ()->
				InstanceActions.traces.visible()
			on: "record"
			todo: (object_name, record_id, fields)->
				InstanceActions.traces.todo(object_name, record_id, fields)
		related_instance:
			label: "关联文件"
			visible: ()->
				InstanceActions.related.visible()
			on: "record"
			todo: (object_name, record_id, fields)->
				InstanceActions.related.todo(object_name, record_id, fields)
		print_instance:
			label: "打印"
			visible: ()->
				InstanceActions.print.visible()
			on: "record"
			todo:(object_name, record_id, fields)->
				InstanceActions.print.todo(object_name, record_id, fields)
		forward_instance:
			label: "转发"
			visible: ()->
				InstanceActions.forward.visible()
			on: "record"
			todo: (object_name, record_id, fields)->
				InstanceActions.forward.todo(object_name, record_id, fields)
		distribute_instance:
			label: "分发"
			visible: ()->
				InstanceActions.distribute.visible()
			on: "record"
			todo: (object_name, record_id, fields)->
				InstanceActions.distribute.todo(object_name, record_id, fields)
		remind_instance:
			label: "催办"
			visible: ()->
				InstanceActions.remind.visible()
			on: "record"
			todo: (object_name, record_id, fields)->
				InstanceActions.remind.todo(object_name, record_id, fields)
		instance_workflow_chart:
			label: "流程图"
			visible: ()->
				InstanceActions.workflow_chart.visible()
			on: "record"
			todo:(object_name, record_id, fields)->
				InstanceActions.workflow_chart.todo(object_name, record_id, fields)