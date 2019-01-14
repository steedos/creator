Creator.Objects.projects =
	name: "projects"
	label: "问题分类"
	icon: "location"
	enable_search: true
	fields:
		name:
			label:'名称'
			type:'text'
			is_wide:true

		description: 
			label: '描述'
			type: 'textarea'
			is_wide: true

	list_views:
		all:
			label: "所有"
			columns: ["name", "description", "created"]
			filter_scope: "space"


	permission_set:
		user:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: false
			modifyAllRecords: false
			viewAllRecords: true
		admin:
			allowCreate: true
			allowDelete: true
			allowEdit: true
			allowRead: true
			modifyAllRecords: true
			viewAllRecords: true