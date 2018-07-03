Creator.Objects.vip_share =
	name: "vip_share"
	label: "分享"
	icon: "address"
	fields:
		name:
			label:'名称'
			type:'text'
			#分享的商品对应的礼物名称
		#分享人就是owner
		related_to:
			label: "关联到"
			type: "lookup"
			reference_to: 'vip_product'
	list_views:
		all:
			label: "所有"
			columns: ["name", "related_to"]
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

		

		