# Creator.Objects.archive_classification =
# 	name: "archive_classification"
# 	icon: "cms"
# 	label: "公文分类"
# 	fields:
# 		_id:
# 			type: "text"
# 			label: "分类ID"
# 			hidden: true
# 		name: 
# 			type: "text"
# 			label: "名称"
# 			required: true

# 	list_views:
# 		all:
# 			label: "全部"
# 			columns: ["name"]
# 			filter_scope: "space"
# 	actions:
# 		standard_query:
# 			label: "查找"
# 			visible: false
# 			on: "list"
# 			todo: "standard_query"