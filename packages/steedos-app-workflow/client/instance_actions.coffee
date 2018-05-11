@InstanceActions = {}

# 新建
InstanceActions.new = {
	visible: ()->
		return true;
	todo: (object_name, record_id, fields)->
		#判断是否为欠费工作区
		if WorkflowManager.isArrearageSpace()
			toastr.error(t("spaces_isarrearageSpace"))
			return;

		Modal.show("flow_list_box_modal")
}

# 保存
InstanceActions.save = {
	visible: ()->
		ins = WorkflowManager.getInstance();
		if !ins
			return false
		flow = db.flows.findOne(ins.flow);
		if !flow
			return false

		if InstanceManager.isInbox()
			return true

		if !ApproveManager.isReadOnly()
			return true
		else
			return false
	todo: (object_name, record_id, fields)->
		element = $(".btn-instance-update")
		if !InstanceEvent.run(element, "instance-before-save")
			return ;

		InstanceManager.saveIns();
		Session.set("instance_change", false);
}

# 删除
InstanceActions.delete = {
	visible: ()->
		ins = WorkflowManager.getInstance();
		if !ins
			return false
		space = db.spaces.findOne(ins.space);
		if !space
			return false

		fl = db.flows.findOne({'_id': ins.flow});
		if !fl
			return false
		curSpaceUser = db.space_users.findOne({space: ins.space, 'user': Meteor.userId()});
		if !curSpaceUser
			return false
		organizations = db.organizations.find({_id: {$in: curSpaceUser.organizations}}).fetch();
		if !organizations
			return false

		if Session.get("box") == "draft" || (Session.get("box") == "monitor" && (space.admins.contains(Meteor.userId()) || WorkflowManager.canAdmin(fl, curSpaceUser, organizations)))
			return true
		else
			return false
	todo: (object_name, record_id, fields)->
		swal {
			title: t("Are you sure?"),
			type: "warning",
			showCancelButton: true,
			cancelButtonText: t('Cancel'),
			confirmButtonColor: "#DD6B55",
			confirmButtonText: t('OK'),
			closeOnConfirm: true
		}, () ->
			Session.set("instance_change", false);
			InstanceManager.deleteIns()
}

# 打印
InstanceActions.print = {
	visible: ()->
		if Meteor.isCordova
			return false
		return true
	todo: (object_name, record_id, fields)->
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
}

# 取消申请
InstanceActions.terminate = {
	visible: ()->
		if Meteor.settings.public?.workflow?.hideTerminateButton
			return false

		ins = WorkflowManager.getInstance();
		if !ins
			return false
		if (Session.get("box") == "pending" || Session.get("box") == "inbox") && ins.state == "pending" && ins.applicant == Meteor.userId()
			return true
		else
			return false
	todo: (object_name, record_id, fields)->
		swal {
			title: t("instance_cancel_title"),
			text: t("instance_cancel_reason"),
			type: "input",
			confirmButtonText: t('OK'),
			cancelButtonText: t('Cancel'),
			showCancelButton: true,
			closeOnConfirm: false
		}, (reason) ->
			# 用户选择取消
			if (reason == false)
				return false;

			if (reason == "")
				swal.showInputError(t("instance_cancel_error_reason_required"));
				return false;

			InstanceManager.terminateIns(reason);
			sweetAlert.close();
}

# 转签核
InstanceActions.reassign = {
	visible: ()->
		ins = WorkflowManager.getInstance();
		if !ins
			return false
		space = db.spaces.findOne(ins.space);
		if !space
			return false
		fl = db.flows.findOne({'_id': ins.flow});
		if !fl
			return false
		curSpaceUser = db.space_users.findOne({space: ins.space, 'user': Meteor.userId()});
		if !curSpaceUser
			return false
		organizations = db.organizations.find({_id: {$in: curSpaceUser.organizations}}).fetch();
		if !organizations
			return false

		if Session.get("box") == "monitor" && ins.state == "pending" && (space.admins.contains(Meteor.userId()) || WorkflowManager.canAdmin(fl, curSpaceUser, organizations))
			return true
		else
			return false
	todo: (object_name, record_id, fields)->
		Modal.show('reassign_modal')
}

# 重定位
InstanceActions.relocate = {
	visible: ()->
		ins = WorkflowManager.getInstance();
		if !ins
			return false
		space = db.spaces.findOne(ins.space);
		if !space
			return false
		fl = db.flows.findOne({'_id': ins.flow});
		if !fl
			return false
		curSpaceUser = db.space_users.findOne({space: ins.space, 'user': Meteor.userId()});
		if !curSpaceUser
			return false
		organizations = db.organizations.find({_id: {$in: curSpaceUser.organizations}}).fetch();
		if !organizations
			return false

		if Session.get("box") == "monitor" && ins.state != "draft" && (space.admins.contains(Meteor.userId()) || WorkflowManager.canAdmin(fl, curSpaceUser, organizations))
			return true
		else
			return false
	todo: (object_name, record_id, fields)->
		Modal.show('relocate_modal')
}

# 传阅
InstanceActions.cc = {
	visible: ()->
		ins = WorkflowManager.getInstance()
		if !ins
			return false
		# 文件结束后，不可以再传阅，也不用再催办。
		if InstanceManager.isInbox() && ins.state is "pending"
			if InstanceManager.isCC(ins)
				return true
			else
				cs = InstanceManager.getCurrentStep()
				if cs && (cs.disableCC is true or cs.step_type is "start")
					return false
				return true
		else if Session.get("box") is 'outbox' and ins.state is "pending"
			step_id = InstanceManager.getLastCCTraceStepId(ins.traces)
			if step_id
				step = WorkflowManager.getInstanceStep(step_id)
				if step and (step.disableCC is true or step.step_type is "start")
					return false
				return true
			else
				return false
		else
			return false
	todo: (object_name, record_id, fields)->
		Modal.show('instance_cc_modal')
}

# 退回
InstanceActions.return = {
	visible: ()->
		ins = WorkflowManager.getInstance()
		if !ins
			return false
		flow = db.flows.findOne(ins.flow)
		if !flow
			return false

		if !InstanceManager.isInbox()
			return false

		if InstanceManager.isCC(ins)
			return false

		if ins.traces.length < 2 # 通过转发生成的文件也在待审核箱中但是状态为draft并且ins.traces.length=1
			return false

		pre_trace = ins.traces[ins.traces.length - 2]

		is_not_return = false
		_.each pre_trace.approves, (ap)->
			if ap.judge is 'relocated' or ap.judge is 'returned' or ap.judge is 'retrieved'
				is_not_return = true
		if is_not_return
			return false

		pre_step = WorkflowManager.getInstanceStep(pre_trace.step)
		if pre_step && pre_step.step_type is "counterSign"
			return false

		cs = InstanceManager.getCurrentStep()
		if _.isEmpty(cs)
			return false
		if cs.step_type is "submit" or cs.step_type is "sign" or cs.step_type is "counterSign"
			return true

		return false
	todo: (object_name, record_id, fields)->
		InstanceManager.returnIns()
}

# 转发
InstanceActions.forward = {
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
	todo: (object_name, record_id, fields)->
		Modal.show("forward_select_flow_modal", {action_type:"forward"})
}

# 分发
InstanceActions.distribute = {
	visible: ()->
		ins = WorkflowManager.getInstance()
		if !ins
			return false

		# 传阅的申请单不允许分发
		if (InstanceManager.isCC(ins))
			return false

		# 设置了允许分发才显示分发按钮
		if InstanceManager.isInbox()
			cs = InstanceManager.getCurrentStep()
			if cs && (cs.allowDistribute is true)
				return true

		if Session.get("box") is 'outbox' and ins.state is "pending"
			step_id = InstanceManager.getLastTraceStepId(ins.traces)
			if step_id
				step = WorkflowManager.getInstanceStep(step_id)
				if step and (step.allowDistribute is true)
					return true

		return false
	todo: (object_name, record_id, fields)->
		Modal.show("forward_select_flow_modal", {action_type:"distribute"})
}

# 取回
InstanceActions.retrieve = {
	visible: ()->
		ins = WorkflowManager.getInstance()
		if !ins
			return false

		if (Session.get('box') is 'outbox' or Session.get('box') is 'pending') and ins.state is 'pending'
			return true

		return false
	todo: (object_name, record_id, fields)->
		ins = WorkflowManager.getInstance()
		traces = ins.traces
		can_retrieve = false
		current_user = Meteor.userId()

		if (Session.get('box') is 'outbox' or Session.get('box') is 'pending') and ins.state isnt 'draft'
			last_trace = _.last(traces)
			previous_trace_id = last_trace.previous_trace_ids[0]
			previous_trace = _.find(traces, (t)->
				return t._id is previous_trace_id
			)
			# 校验当前步骤是否已读
			is_read = false
			_.each last_trace.approves, (ap)->
				if ap.is_read is true
					is_read = true
			# 取回步骤的前一个步骤处理人唯一（即排除掉传阅和转发的approve后，剩余的approve只有一个）并且是当前用户
			previous_trace_approves = _.filter previous_trace.approves, (a)->
				return a.type isnt 'cc' and a.type isnt 'distribute' and ['approved','submitted','rejected'].includes(a.judge)

			if previous_trace_approves.length is 1 and (previous_trace_approves[0].user is current_user or previous_trace_approves[0].handler is current_user) and not is_read
				can_retrieve = true

		i = traces.length
		while i > 0
			_.each traces[i-1].approves, (a)->
				if a.type is 'cc' and a.is_finished is true and a.user is current_user
					can_retrieve = true
			if can_retrieve is true
				break
			i--

		if can_retrieve
			swal {
				title: t("instance_retrieve"),
				inputPlaceholder: t("instance_retrieve_reason"),
				type: "input",
				confirmButtonText: t('OK'),
				cancelButtonText: t('Cancel'),
				showCancelButton: true,
				closeOnConfirm: false
			}, (reason) ->
				# 用户选择取消
				if (reason == false)
					return false;

				InstanceManager.retrieveIns(reason);
				sweetAlert.close();
		else
			swal({
				title: t("instance_retrieve_rules_title"),
				text: "<div style='overflow-x:auto;'>#{t('instance_retrieve_rules_content')}<div>",
				html: true,
				confirmButtonText: t('OK')
			})
}

# 签核历程
InstanceActions.traces = {
	visible: ()->
		if Session.get("box") == "draft"
			return false
		else
			ins = WorkflowManager.getInstance();
			if ins
				if !TracesTemplate.helpers.showTracesView(ins.form, ins.form_version)
					return true
	todo: (object_name, record_id, fields)->
		ins = WorkflowManager.getInstance();
		if !TracesTemplate.helpers.showTracesView(ins.form, ins.form_version)
			$("body").addClass("loading")
			#延迟一毫秒弹出Modal，否则导致loading显示不出来
			Meteor.setTimeout ()->
				Modal.show("traces_table_modal")
			, 1

		else
			$(".instance").scrollTop($(".instance .instance-form").height())
}

# 关联文件
InstanceActions.related = {
	visible: ()->
		if Session.get("box") == "draft"
			current_step = InstanceManager.getCurrentStep()
			if current_step
				if (current_step.can_edit_main_attach || current_step.can_edit_normal_attach == true || current_step.can_edit_normal_attach == undefined)
					return true
		else
			return false
	todo: (object_name, record_id, fields)->
		if !Steedos.isPaidSpace()
			Steedos.spaceUpgradedModal()
			return;
		Modal.show("related_instances_modal")
}

# 签批
InstanceActions.suggest = {
	visible: ()->
		return false
	todo: (object_name, record_id, fields)->
		$(".instance-wrapper .instance-view").addClass("suggestion-active")
		InstanceManager.fixInstancePosition()
}

# 催办
InstanceActions.remind = {
	visible: ()->
		ins = WorkflowManager.getInstance()
		if !ins
			return false

		# 文件结束后，不可以再传阅，也不用再催办。
		if ins.state != "pending"
			return false

		values = ins.values || new Object

		try
			if values.priority and values.deadline
				check values.priority, Match.OneOf('普通', '办文', '紧急', '特急')
				# 由于values中的date字段的值为String，故作如下校验
				if new Date(values.deadline).toString() is "Invalid Date"
					return false
		catch e
			return false

		return true
	todo: (object_name, record_id, fields)->
		param = { action_types: new ReactiveVar([]) }
		Modal.show 'remind_modal', param
}

# 提交
InstanceActions.submit = {
	visible: ()->
		ins = WorkflowManager.getInstance();
		if !ins
			return false

		flow = db.flows.findOne({_id: ins.flow}, {fields: {state: 1}})
		if flow and flow.state is 'disabled'
			return false

		if InstanceManager.isInbox() || Session.get('box') is "draft"
			return true

		return false
	todo: (object_name, record_id, fields)->
		InstanceManager.btnInstanceSubmit()
}

# 流程图
InstanceActions.workflow_chart = {
	visible: ()->
		return Session.get("list_view_id") == "inbox" && Session.get("instanceId")
	todo: (object_name, record_id, fields)->
		if Steedos.isIE()
			toastr.warning t("instance_workflow_chart_ie_warning")
			return
		ins = WorkflowManager.getInstance()
		flow = db.flows.findOne(ins.flow)
		Steedos.openWindow(Steedos.absoluteUrl("/packages/steedos_workflow-chart/assets/index.html?instance_id=#{ins._id}&title=#{encodeURIComponent(encodeURIComponent(flow.name))}"),'workflow_chart')
}