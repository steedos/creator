Creator.Reports.company_martrix =
	name: "Customer List"
	object_name: "companies"
	report_type: "summary"
	filter_scope: "space"
	filters: []
	columns: ["created"]
	rows: ["priority"]
	values: [{
		label: '客户数量'
		field: "name"
		operation: "count"
	}]