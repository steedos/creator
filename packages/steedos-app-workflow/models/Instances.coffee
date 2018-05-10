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
				console.log("sub instance ready.....fasle 1")
				return false;

			if instance.flow_version && instance.form_version
				flow_version = db.flow_versions.findOne({_id: instance.flow_version})

				form_version = db.form_versions.findOne({_id: instance.form_version})

				if !flow_version || !form_version
					console.log("sub instance ready.....fasle 2")
					return false;

			if instance
				if Session.get("box") == "inbox"
					if InstanceManager.isInbox()
						return true
					else
						FlowRouter.go("/workflow/space/" + Session.get("spaceId") + "/" + Session.get("box") + "/")
				else
					return true
			else # 订阅完成 instance 不存在，则认为instance 已经被删除
				FlowRouter.go("/workflow/space/" + Session.get("spaceId") + "/" + Session.get("box") + "/")
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
			visible: true
			on: "list"
			todo: (object_name)->
				Modal.show("flow_list_box_modal")
		submit_instance:
			label: "发送"
			visible: ()->
				return Session.get("list_view_id") == "inbox" && Session.get("instanceId")
			on: "record"
			todo: (object_name, record_id, fields)->
				InstanceManager.btnInstanceSubmit()
		cc_instance:
			label: "传阅"
			visible: ()->
				return Session.get("list_view_id") == "inbox" && Session.get("instanceId")
			on: "record"
			todo:(object_name, record_id, fields)->
				Modal.show('instance_cc_modal');
		save_instance:
			label: "保存"
			visible: ()->
				return Session.get("list_view_id") == "inbox" && Session.get("instanceId")
			on: "record"
			todo:(object_name, record_id, fields)->
				element = $(".btn-instance-update")
				if !InstanceEvent.run(element, "instance-before-save")
					return ;

				InstanceManager.saveIns();
				Session.set("instance_change", false);
		return_instance:
			label: "退回"
			visible: ()->
				return Session.get("list_view_id") == "inbox" && Session.get("instanceId")
			on: "record"
			todo:(object_name, record_id, fields)->
				InstanceManager.returnIns()
		print_instance:
			label: "打印"
			visible: ()->
				if Meteor.isCordova
					return false
				return true
			on: "record"
			todo:(object_name, record_id, fields)->
				if window.navigator.userAgent.toLocaleLowerCase().indexOf("chrome") < 0
					toastr.warning(TAPi18n.__("instance_chrome_print_warning"))
				else
					btn_instance_update = $('.btn-instance-update')[0]
					if btn_instance_update
						btn_instance_update.click()
					uobj = {}
					uobj["box"] = Session.get("box")
					uobj["X-User-Id"] = Meteor.userId()
					uobj["X-Auth-Token"] = Accounts._storedLoginToken()
					Steedos.openWindow(Steedos.absoluteUrl("workflow/space/" + Session.get("spaceId") + "/print/" + record_id + "?" + $.param(uobj)), "",'width=900,height=750,scrollbars=yes,EnableViewPortScale=yes,toolbarposition=top,transitionstyle=fliphorizontal,menubar=yes,closebuttoncaption=  x  ')
		forward_instance:
			label: "转发"
			visible: ()->
				if Meteor.settings.public?.workflow?.disableInstanceForward
					return false

				ins = WorkflowManager.getInstance()
				if !ins
					return false

				# 传阅的申请单不允许转发
				if (InstanceManager.isCC(ins))
					return false

				# 待审核箱不显示转发
				if InstanceManager.isInbox()
					return false

				if ins.state != "draft"
					return true
				else
					return false
			on: "record"
			todo: ()->
				Modal.show("forward_select_flow_modal", {action_type:"forward"})
		remind_instance:
			label: "催办"
			visible: ()->
				return Session.get("list_view_id") == "inbox" && Session.get("instanceId")
			on: "record"
			todo: ()->
				param = { action_types: new ReactiveVar([]) }
				Modal.show 'remind_modal', param
		instance_workflow_chart:
			label: "流程图"
			visible: ()->
				return Session.get("list_view_id") == "inbox" && Session.get("instanceId")
			on: "record"
			todo:(object_name, record_id, fields)->
				if Steedos.isIE()
					toastr.warning t("instance_workflow_chart_ie_warning")
					return
				ins = WorkflowManager.getInstance()
				flow = db.flows.findOne(ins.flow)
				Steedos.openWindow(Steedos.absoluteUrl("/packages/steedos_workflow-chart/assets/index.html?instance_id=#{ins._id}&title=#{encodeURIComponent(encodeURIComponent(flow.name))}"),'workflow_chart')
		view_instance:
			label: "查看申请单"
			visible: false
			on: "record"
			todo: (object_name, record_id, fields)->
				uobj = {}
				uobj["box"] = 'monitor'
				uobj["X-User-Id"] = Meteor.userId()
				uobj["X-Auth-Token"] = Accounts._storedLoginToken()
				workflowUrl = window.location.protocol + '//' + window.location.hostname + '/'
				Steedos.openWindow(workflowUrl + "workflow/space/" + Session.get("spaceId") + "/print/" + record_id + "?" + $.param(uobj), "",'width=900,height=750,scrollbars=yes,EnableViewPortScale=yes,toolbarposition=top,transitionstyle=fliphorizontal,menubar=yes,closebuttoncaption=  x  ')