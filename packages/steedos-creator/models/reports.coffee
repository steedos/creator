Creator.Objects.reports = 
	name: "reports"
	label: "reports"
	icon: "report"
	fields:
		name: 
			type: "text"
			required: true
		description: 
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
			type: "text"
			required: true
		filters: 
			type: [Object]
		"filters.$.field": 
			label: "字段"
			type: "text"
		"filters.$.operation": 
			label: "操作符"
			type: "select"
			defaultValue: "tabular"
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
			type: "[text]"
		rows: 
			type: "[text]"
		groups: 
			type: "[text]"
		values: 
			type: [Object]
			blackbox: true
		"values.$.label":
			type: "text"
		"values.$.field":
			type: "text"
		"values.$.operation":
			type: "text"
		"values.$.grouping":
			type: "boolean"
			defaultValue: false

	list_views:
		default:
			columns: ["name", "report_type", "object_name"]
		all:
			filter_scope: "space"
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