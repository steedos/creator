Creator.Objects.project_issues =
	name: "project_issues"
	label: "问题"
	icon: "location"
	enable_files: true
	enable_search: true
	enable_tasks: true
	fields:
		name:
			label: '标题'
			type: 'text'
			is_wide: true
			required: true

		description: 
			label: '问题描述'
			type: 'textarea'
			is_wide: true
			rows: 8

		category:
			label: '分类'
			type: 'master_detail'
			reference_to: 'projects'
			required: true

		state:
			label: "状态"
			type: "select"
			options: [
				{label:"草稿", value:"draft"}, 
				{label:"待确认", value:"pending_confirm"}, 
				{label:"处理中", value:"in_progress"}, 
				{label:"暂停", value:"paused"}, 
				{label: "已完成", value:"completed"}
				{label: "已取消", value:"cancelled"}
			]
			sortable: true
			required: true

		priority:
			label: '优先级'
			type: "select"
			options: [
				{label:"高", value:"high"}, 
				{label:"中", value:"medium"}, 
				{label:"低", value:"low"}
			]


	list_views:
		all:
			label: "所有"
			columns: ["name", "category", "owner", "created", "state"]
			filter_scope: "space"
		draft:
			label: "草稿"
			columns: ["name", "category", "assignees", "created", "state"]
			filter_scope: "space"
			filters: [["created_by", "=", "{userId}"]]
		pending_confirm:
			label: "待确认"
			columns: ["name", "category", "created_by", "created"]
			filter_scope: "space"
			filters: [["state", "=", "pending_confirm"]]
		in_progress:
			label: "处理中"
			columns: ["name", "category", "assignees", "due_date"]
			filter_scope: "space"
			filters: [["state", "=", "in_progress"]]
		paused:
			label: "暂停"
			columns: ["name", "category", "created_by", "created"]
			filter_scope: "space"
			filters: [["state", "=", "paused"]]
		completed:
			label: "已完成"
			columns: ["name", "category", "created_by", "created"]
			filter_scope: "space"
			filters: [["state", "=", "completed"]]


	permission_set:
		user:
			allowCreate: true
			allowDelete: true
			allowEdit: true
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