Creator.Objects.archive_document =
	name: "archive_document"
	icon: "drafts"
	label: "文件归档"
	enable_search: true
	enable_files: true
	enable_api: true
	open_window: false
	fields:
		name:
			type: "text"
			label: "标题"
			sortable: true
			default_width: 600
		organization:
			type: "lookup"
			label: "部门"
			reference_to: "organizations"
		flow_category:
			type: "lookup"
			label: "流程分类"
			reference_to: "categories"
		flow:
			type: "lookup"
			label: "流程"
			reference_to: "flows"
			depend_on: ["flow_category"]
			filtersFunction: (filters, context) ->
				console.log('filtersFunction', filters, context);
				if _.isArray(context?.flow_category)
					fs = []
					_.each context.flow_category, (fc)->
						fs.push("(category eq '#{fc}')")
					return "(#{fs.join(' and ')})"
				else if _.isString(context?.flow_category) && !_.isEmpty(context?.flow_category)
					return "(category eq '#{context.flow_category}')"
		flow_name:
			type: "text"
			label: "流程名称"
			sortable: true
			default_width: 300
		state:
			type: "select"
			label: "审批结果"
			options:[
				{label: "审批中",value: "pending"},
				{label: "已核准",value: "approved"},
				{label: "已驳回",value: "rejected"},
				{label: "已取消",value: "terminated"},
				{label: "已签订",value: "signed"},
				{label: "已归档",value: "archived"},
				{label: "已作废",value: "droped"},
				{label: "已完成",value: "completed"}],
			allowedValues:["pending","approved","rejected","terminated","signed","archived","droped","completed"]
		submitter:
			type: "lookup"
			label: "提交人"
			sortable: true
			reference_to: "users"
			default_width: 150
		submit_date:
			type: "datetime"
			label: "提交时间"
			sortable: true
			searchable: true
			default_width: 180
		archive_date:
			type: "datetime"
			label: "归档时间"
			sortable: true
			hidden: true
			default_width: 180
		outbox_users:
			type: "[text]"
			label: "处理人"
			omit: true
			hidden: true
		external_id:
			type: "text"
			label: '表单ID'
			hidden: true
	list_views:
		all:
			label: "全部"
			filter_scope: "space"
			filters: [[["submitter", "=", "{userId}"], 'or', ["outbox_users", "=", "{userId}"]],["state","=","completed"]]
			columns: ["name", "flow_name", "submitter", "submit_date"]
			sort: [{field_name: "submit_date", order: "desc"}]	
		submit:
			label: "我发起的"
			filter_scope: "space"
			filters: [["submitter", "=", "{userId}"],["state","=","completed"]]
			columns: ["name", "flow_name", "submitter", "submit_date"]
			sort: [{field_name: "submit_date", order: "desc"}]
		approved:
			label: "我审核的"
			filter_scope: "space"
			filters: [["outbox_users", "=", "{userId}"],["state","=","completed"]]
			columns: ["name", "flow_name", "submitter", "submit_date"]
			sort: [{field_name: "submit_date", order: "desc"}]

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

	actions:
		standard_view:
			label: "查看表单"
			visible: true
			on: "record"
			todo: (object_name, record_id)->
				if record_id
					Meteor.call "archive_view", record_id, (error, result) ->
						if result
							if result == ""
								toastr.error "未找到html！"
							console.log "result", result
							Steedos.openWindow(result)


		