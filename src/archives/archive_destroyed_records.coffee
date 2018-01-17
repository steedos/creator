Creator.Objects.archive_destroyed_records = 
	name: "archive_destroyed_records"
	icon: "product_item"
	label: "销毁"
	enable_search: true
	fields:
		reason:
			label:"销毁原因"
			type:"textarea"
			is_wide:true
		records_id:
			label: "文书档案"
			type: "master_detail"
			reference_to: "archive_records"
			is_wide:true
			multiple:true
	list_views:
		default:
			columns:["records_id","reason","created","created_by"]

