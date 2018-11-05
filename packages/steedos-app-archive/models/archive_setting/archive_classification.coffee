Creator.Objects.archive_classification = 
	name: "archive_classification"
	icon: "drafts"
	label: "公文分类"
	enable_search: true
	enable_tree: true
	fields:
		_id:
			type: "text"
			label: "分类ID"
			hidden: true
		parent:
			type: "lookup"
			label: "上级"
			reference_to: "archive_classification"
			sortable: true
		name:
			type: "text"
			label: "名称"
	list_views:
		all:
			label: "全部"
			filter_scope: "space"
			columns:["name","parent"]