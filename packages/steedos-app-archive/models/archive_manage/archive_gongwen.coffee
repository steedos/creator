Creator.Objects.archive_gongwen =
	name: "archive_gongwen"
	icon: "record"
	label: "公文档案"
	enable_search: true
	enable_files: true
	enable_api: true
	fields:
		title:
			type:"textarea"
			label:"题名"
			is_wide:true
			is_name:true
			required:true
			sortable:true
			searchable:true
		
		#如果是从OA归档过来的档案，则值为表单Id,否则不存在该字段
		# OA系统的表单ID
		external_id:
			type:"text"
			label:'表单ID'
			hidden: true


	list_views:
		recent:
			label: "最近查看"
			filter_scope: "space"
			columns:['item_number','archival_code',"author","title","electronic_record_code","total_number_of_pages","annotation",'archive_transfer_id']
		all:
			label: "全部"
			filter_scope: "space"
			columns:['item_number','archival_code',"author","title","electronic_record_code","total_number_of_pages","annotation",'archive_transfer_id']

	permission_set:
		user:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true
			list_views:["default","recent","all"]
		admin:
			allowCreate: true
			allowDelete: true
			allowEdit: true
			allowRead: true
			modifyAllRecords: true
			viewAllRecords: true
			list_views:["default","recent","all"]