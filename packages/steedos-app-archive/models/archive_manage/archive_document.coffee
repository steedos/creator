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
		name:
			type: "text"
			label: "标题"
		submitter:
			type: "lookup"
			label: "提交人"
			reference_to: "users"
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
		flow_name:
			type: "text"
			label: "流程归档时候的名称"
		state:
			type: "text"
			label: "审批结果"
		organization:
			type: "text"
			label: "部门"
		