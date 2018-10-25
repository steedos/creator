Creator.Objects.archive_document = 
	name: "archive_document"
	icon: "record"
	label: "公文管理"
	enable_search: true
	enable_files: true
	enable_api: true
	fields:
		classification_id:
			type: "text"
			label: "分类ID"
			reference_to: "archive_classification"
			hidden: true
		name:
			type: "text"
			label: "标题"
		submitter:
			type: "lookup"
			label: "提交人"
			reference_to: "users"
		organization:
			type: "text"
			label: "部门"
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
		flow_name:
			type: "text"
			label: "流程归档时候的名称"
		state:
			type: "text"
			label: "审批结果"

	list_views:
		recent:
			label: "最近查看"
			filter_scope: "space"
		all:
			label: "全部"
			filter_scope: "space"
			columns:["name","submitter","submit_date","archive_date","outbox_users","flow_name","state","organization"]
		