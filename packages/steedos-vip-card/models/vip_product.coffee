Creator.Objects.vip_product =
	name: "vip_product"
	label: "商品"
	icon: "product"
	enable_files:true
	fields:
		name:
			label:'名称'
			type:'text'
			is_wide:true
			required:true
		default_price:
			label:'价格'
			type:'number'
			required:true
			scale: 2
		compared_price:
			label:'原价'
			type:'number'
			scale: 2
		description:
			label:'备注'
			type:'text'
			is_wide:true
		covers:
			label:'轮播图'
			type:'image'
			multiple:true
		avatar:
			label:'展示图'
			type:'image'
			required:true
		video:
			label:'视频'
			type:'video'
		categories:
			label:'分类'
			type:'text'  
			multiple:true
			required:true
		tags:
			label:'标签'
			type:'text'
			required:true
		vendor:
			label:'供应商'
			type:'text' 
		status:
			label:'状态'
			type:'text'
			#草稿，上架，下架
		weight:
			label:'重量'
			type:'number'   
			scale: 2
	list_views:
		all:
			label: "所有"
			columns: ["name", "default_price", "compared_price", "avatar", "categories"]
			filter_scope: "space"
	permission_set:
		user:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: true
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
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true
		guest:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true

		