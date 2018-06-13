Creator.Objects.archive_classification = 
	name: "archive_classification"
	icon: "product_item"
	label: "分类表"
	enable_search: true
	fields:
		name:
			type:"text"
			label:"分类名称"
			is_name:true
			required:true
			searchable:true
			index:true
		match_rules:
			label: "匹配规则"
			type: "grid"
		"match_rules.$":
			blackbox: true
			type: "Object"
		"match_rules.$.field":
			label:"匹配字段"
			type:"lookup"
			optionsFunction: (values)->
				return Creator.getObjectLookupFieldOptions "archive_wenshu", true
		"match_rules.$.operation":
			label:"匹配操作"
			type:"select"
			options : [
				{label: "等于" ,value: "="},
				{label: "不等于", value: "<>"},
				{label: "小于", value: "<"},
				{label: "大于", value: ">"},
				{label: "小于等于", value: "<="},
				{label: "大于等于", value: ">="},
				{label: "包含", value: "contains"},
				{label: "不包含", value: "notcontains"},
				{label: "开始", value: "startswith"}
			]
			allowedValues:["=","<>","<",">","<=",">=","contains","notcontains","startswith"]
		"match_rules.$.value":
			type:'text'
			label:'匹配值'
		sort_no:
			type:'Number'
			label:"排序号"
			index:true
		parent:
			type:"lookup"
			label:"上级分类"
			reference_to:"archive_classification"
			multiple:true
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
		all:
			label:"全部分类"
			filter_scope: "space"
			columns:["name","parent","match_rules","sort_no"]