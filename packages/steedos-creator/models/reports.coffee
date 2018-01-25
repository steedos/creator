Creator.Objects.reports = 
	name: "reports"
	label: "报表"
	icon: "report"
	fields:
		name: 
			label: "名称"
			type: "text"
			required: true
		description: 
			label: "描述"
			type: "textarea"
			is_wide: true
		report_type:
			label: "报表类型"
			type: "select"
			defaultValue: "tabular"
			options: [
				{label: "列表", value: "tabular"},
				{label: "汇总", value: "summary"},
				{label: "矩阵", value: "matrix"}
			]
		object_name: 
			label: "对象名"
			type: "text"
			required: true
		filter_scope:
			label: "过虑范围"
			type: "select"
			defaultValue: "space"
			options: [
				{label: "所有", value: "space"},
				{label: "与我相关", value: "mine"}
			]
		filters: 
			label: "过虑条件"
			type: [Object]
		"filters.$.field": 
			label: "字段名"
			type: "text"
		"filters.$.operation": 
			label: "操作符"
			type: "select"
			defaultValue: "EQUALS"
			options: [
				{label: "equals", value: "EQUALS"},
				{label: "not equal to", value: "NOT_EQUAL"},
				{label: "less than", value: "LESS_THAN"},
				{label: "greater than", value: "GREATER_THAN"},
				{label: "less or equal", value: "LESS_OR_EQUAL"},
				{label: "greater or equal", value: "GREATER_OR_EQUAL"},
				{label: "contains", value: "CONTAINS"},
				{label: "does not contain", value: "NOT_CONTAIN"},
				{label: "starts with", value: "STARTS_WITH"},
			]
		"filters.$.value": 
			label: "字段值"
			type: "text"
		columns:
			label: "显示列"
			type: "[text]"
		rows: 
			label: "显示行"
			type: "[text]"
		groups: 
			label: "分组"
			type: "[text]"
		values: 
			label: "统计"
			type: "[text]"
		# values: 
		# 	label: "统计"
		# 	type: [Object]
		# 	blackbox: true
		# "values.$.label":
		# 	label: "标题"
		# 	type: "text"
		# "values.$.field":
		# 	label: "字段名"
		# 	type: "text"
		# "values.$.operation":
		# 	label: "统计类型"
		# 	type: "select"
		# 	defaultValue: "count"
		# 	options: [
		# 		{label: "计数", value: "count"},
		# 		{label: "最大值", value: "max"},
		# 		{label: "最小值", value: "min"},
		# 		{label: "汇总", value: "sum"}
		# 	]
		# "values.$.grouping":
		# 	label: "是否分组统计"
		# 	type: "boolean"
		# 	defaultValue: false
		grouping:
			label: "显示小计"
			type: "boolean"
			defaultValue: true
		totaling:
			label: "显示总计"
			type: "boolean"
			defaultValue: true

	list_views:
		default:
			columns: ["name", "report_type", "object_name"]
		recent:
			label: "最近查看"
			filter_scope: "space"
		all:
			label: "所有报表"
			filter_scope: "space"
		mine:
			label: "我的报表"
			filter_scope: "mine"
	permission_set:
		user:
			allowCreate: true
			allowDelete: true
			allowEdit: true
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: false 
		admin:
			allowCreate: true
			allowDelete: true
			allowEdit: true
			allowRead: true
			modifyAllRecords: true
			viewAllRecords: true 