Creator.Reports.company_matrix =
	name: "Customer List"
	object_name: "companies"
	report_type: "matrix"
	filter_scope: "space"
	filters: []
	columns: ["created"]
	rows: ["priority"]
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
	columns: ["name", "phone", "fax", "owner", "created"]
	groups: ["priority"]
	values: [{
		label: '客户数量'
		field: "name"
		operation: "count"
	}]