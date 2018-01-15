Creator.Reports.crm_customer_list =
	name: "Customer List"
	object_name: "companies"
	report_type: "summary"
	filter_scope: "space"
	filters: []
	columns: ["priority"]
	rows: ["owner"]
	values: [{
		label: '客户数量'
		field: "name"
		operation: "count"
	}]