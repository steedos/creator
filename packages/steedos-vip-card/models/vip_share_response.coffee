Creator.Objects.vip_share_response =
	name: "vip_share_response"
	label: "响应分享"
	icon: "address"
	fields:
		name:
			label:'名称'
			type:'text'
			#owner.name
		vip_share:
			label:'相关分享'
			type:'lookup'
			reference_to:'vip_share'
		related_to:
			label: "关联到"
			type: "lookup"
			reference_to: 'vip_product'
	list_views:
		all:
			label: "所有"
			columns: ["name", "owner","vip_share"]
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
