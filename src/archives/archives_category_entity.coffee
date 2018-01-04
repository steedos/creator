Creator.Objects.archives_category_entity = 
	name: "archives_category_entity"
	icon: ""
	label: "实体分类"
	fields:
		parentname:
			type:"lookup"
			label:"所属分类"
			reference_to: "archives_category_entity"
			sortable:true

		name:
			type:"text"
			label:"分类名"
			is_name:true
			required:true
			sortable:true
		
	list_views:
		default:
			columns:["parentname","name"]
		all:
			label:"全部分类"