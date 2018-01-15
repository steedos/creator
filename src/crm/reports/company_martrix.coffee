Creator.Reports.company_matrix =
	name: "Customer List"
	object_name: "companies"
	report_type: "matrix"
	filter_scope: "space"
	filters: []
	columns: ["created"]
	rows: ["owner.name"]
	values: [{
		label: '客户数量'
		field: "name"
		operation: "count"
	}]


Creator.Reports.company_summary =
	name: "Customer List"
	object_name: "companies"
	report_type: "summary"
	filter_scope: "space"
	filters: []
	columns: ["name", "phone", "fax", "owner.name", "created"]
	groups: ["priority"]


Creator.Reports.company_tabular =
	name: "Customer List"
	object_name: "companies"
	report_type: "tabular"
	filter_scope: "space"
	filters: []
	columns: ["name", "priority.label", "phone", "fax", "owner.name", "created"]