Creator.Reports.contact_matrix =
	name: "Contact List"
	object_name: "contacts"
	report_type: "matrix"
	filter_scope: "space"
	filters: []
	columns: ["created"]
	rows: ["account_id.name"]
	values: [{
		label: '关联数量'
		field: "name"
		operation: "count"
	}]

Creator.Reports.contact_summary =
	name: "Contact List"
	object_name: "contacts"
	report_type: "summary"
	filter_scope: "space"
	filters: []
	columns: ["name", "birthdate", "department", "owner.name", "created"]
	groups: ["account_id.name"]
	values: [{
		field: "account_id"
		operation: "count"
		grouping: true
	},{
		field: "created"
		operation: "max"
		grouping: true
	},{
		label: '汇总计数：{0}'
		field: "name"
		operation: "count"
	}]


Creator.Reports.contact_tabular =
	name: "Contact List"
	object_name: "contacts"
	report_type: "tabular"
	filter_scope: "space"
	filters: []
	columns: ["name", "account_id.name", "birthdate", "department", "owner.name", "created"]