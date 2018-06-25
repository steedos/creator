Creator.Objects.post_category =
	name: "post_category"
	label: "动态栏目"
	icon: "post"
	enable_files:true
	fields:
		name:
			label:'名称'
			type:'text'
			required:true
		sort_no:
			label:'排序号'
			type:'number'
		description:
			label:'描述'
			type:'textarea'
			required:true
			is_wide:true
		cover:
			label: "封面图"
			type:'image'
	list_views:
		all:
			label: "所有"
			columns: ["name", "sort_no", "description"]
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
		member:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: false
			modifyAllRecords: false
			viewAllRecords: false
		guest:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: false
			modifyAllRecords: false
			viewAllRecords: false

