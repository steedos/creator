Creator.Objects.archive_document = 
	name: "archive_document"
	icon: "drafts"
	label: "文件归档"
	enable_search: true
	enable_files: true
	enable_api: true
	open_window: false
	fields:
		classification:
			type: "lookup"
			label: "流程分类"
			reference_to: "archive_classification"
			hidden: true
		name:
			type: "text"
			label: "标题"
		flow_name:
			type: "text"
			label: "流程名称"
		submitter:
			type: "lookup"
			label: "提交人"
			reference_to: "users"
		organization:
			type: "text"
			label: "部门"
			hidden: true
		submit_date:
			type: "datetime"
			label: "提交时间"
			sortable: true
		archive_date:
			type: "datetime"
			label: "归档时间"
			sortable: true
		outbox_users:
			type: ["text"]
			label: "处理人"
			omit: true
			hidden: true
		external_id:
			type:"text"
			label:'表单ID'
			hidden: true
		state:
			type: "text"
			label: "审批结果"
			hidden: true

	list_views:
		recent:
			label: "最近查看"
			filter_scope: "space"
		all:
			label: "全部"
			filter_scope: "space"
			columns:["name","flow_name","submitter","submit_date","archive_date"]
	
	actions:
		standard_view:
			label: "查看表单"
			visible:true
			on: "record"
			todo:(object_name, record_id)->
				if record_id
					Meteor.call "archive_view", record_id, (error,result) ->
						if result 
							if result == ""
								toastr.error "未找到html！"							
							
							Steedos.openWindow(result)


		