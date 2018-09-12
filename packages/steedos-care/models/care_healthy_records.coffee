Creator.Objects.care_healthy_records = 
	name: "care_healthy_records"
	icon: "contact"
	label: "健康记录"
	enable_search: true
	fields:
		username: 
			type: "lookup"
			label:"cch编号和孩子姓名"
			required: true
			reference_to: "care_medical_records"
		
		name: 
			type: "text"
			label:"疾病名称"
			searchable:true

		age: 
			type: "number"
			label:"孩子年龄（月）"
			required: true
			index:true


		height:  	
			type: "number"
			label:"身高（cm）"
			index:true

		weight:  	
			type: "number"
			label:"体重（kg）"
			index:true

		photo_link: 
			type: "image"
			label:"照片"
			multiple : true

		story:
			type: "textarea"
			label:"成长小故事"
			is_wide:true



		care_records: 
			type: "textarea"
			label:"就医过程"
			is_wide: true

		owner:
			hidden:true

		created:
			hidden:true

		created_by:
			hidden:true

		modified:
			hidden:true
		
		modified_by:
			hidden:true
		
	list_views:
		all:
			label: "所有"
			columns: ["name", "username", "age", "height","weight","story","care_records"]
			filter_scope: "space"

	permission_set:
		user:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: false
			modifyAllRecords: false
			viewAllRecords: false
		admin:
			allowCreate: true
			allowDelete: true
			allowEdit: true
			allowRead: true
			modifyAllRecords: true
			viewAllRecords: true
