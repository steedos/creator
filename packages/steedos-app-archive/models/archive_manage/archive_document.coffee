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
			default_width: 600
		flow_name:
			type: "text"
			label: "流程名称"
			default_width: 300
		submitter:
			type: "lookup"
			label: "提交人"
			reference_to: "users"
			default_width: 150
		organization:
			type: "text"
			label: "部门"
			hidden: true
		submit_date:
			type: "datetime"
			label: "提交时间"
			sortable: true
			default_width: 180
		archive_date:
			type: "datetime"
			label: "归档时间"
			sortable: true
			default_width: 180
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
			visible:true
			on: "record"
			todo:(object_name, record_id)->
				if record_id
					Meteor.call "archive_view", record_id, (error,result) ->
						if result 
							if result == ""
								toastr.error "未找到html！"							
							
							Steedos.openWindow(result)


		