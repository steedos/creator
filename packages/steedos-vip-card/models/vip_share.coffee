Creator.Objects.vip_share =
	name: "vip_share"
	label: "分享"
	icon: "address"
	fields:
		name:
			label:'分享人'
			type:'text'
			#owner.name
		#分享人就是owner
		related_to:
			label: "关联到"
			type: "lookup"
			reference_to: 'vip_product'
	list_views:
		all:
			label: "所有"
			columns: ["name", "related_to","created"]
			filter_scope: "space"
	permission_set:
		user:
			allowCreate: true
			allowDelete: true
			allowEdit: false
			allowRead: true
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
			allowCreate: true
			allowDelete: true
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: false
		guest:
			allowCreate: true
			allowDelete: true
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: false

		

		