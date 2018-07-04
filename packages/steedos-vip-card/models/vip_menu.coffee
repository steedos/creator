Creator.Objects.vip_menu =
	name: "vip_menu"
	label: "菜单"
	icon: "lead_list"
	enable_files:true
	fields:
		name:
			label:'名称'
			type:'text'
		avatar:
			label:'图标图片'
			type:'image'
		related_to:
			label: "关联到"
			type: "lookup"
			reference_to: ['post','post_category','vip_product','vip_product_category','vip_event','vip_store']
			# options:[
			# 	{label:'动态',value:'post'},
			# 	{label:'栏目',value:'post_category'},
			# 	{label:'商品',value:'vip_product'},
			# 	{label:'商品分类',value:'vip_product_category'},
			# 	{label:'活动',value:c},
			# ]
		sort_no:
			label:'排序号'
			type:'number'
		enabled:
			label:'是否启用'
			type:'boolean'
	list_views:
		all:
			label: "所有"
			columns: ["name", "sort_no", "enabled", "related_to"]
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
		member:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: false
			modifyAllRecords: false
			viewAllRecords: true
		guest:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: false
			modifyAllRecords: false
			viewAllRecords: true
		 
