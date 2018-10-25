Creator.Objects.archive_classification = 
	name: "archive_classification"
	icon: "note"
	label: "公文分类"
	enable_search: true
	fields:
		_id:
			type: "text"
			label: "分类ID"
		parent:
			type: "lookup"
			label: "上级"
			reference_to: "archive_classification"
			sortable: true
		name:
			type: "text"
			label: "名称"