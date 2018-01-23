Creator.Objects.archive_rules = 
	name: "archive_rules"
	icon: "timeslot"
	label: "分类规则"
	enable_search: false
	fields:
		fieldname:
			type:"select"
			label:"匹配字段"
			options: [
				{label:"标题",value:"title"},
				{label:"部门",value:"dept"}
			]
			defaultValue:"title"
		classification:
			type:"master_detail"
			label:"所属分类"
			reference_to:"archive_classification"
		keywords:
			type:"text"
			label:"关键词"
			is_wide:true
	permission_set:
		user:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: false
			modifyAllRecords: false
			viewAllRecords: false 
		admin:
			allowCreate: true
			allowDelete: true
			allowEdit: true
			allowRead: true
			modifyAllRecords: true
			viewAllRecords: true 
	list_views:
		default:
			columns:["fieldname","classification","keywords"]
		all:
			label:"全部分类规则"

