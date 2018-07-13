Creator.Objects.vip_share_response =
	name: "vip_share_response"
	label: "响应分享"
	icon: "partners"
	fields:
		name: # 值格式: 分享人姓名 分享给 被分享人姓名
			label:'响应人'
			type:'text'
			#owner.name
		from:
			label:'来自'
			type:'lookup'
			reference_to:'users'
		product:
			label: "商品"
			type: "lookup"
			reference_to: 'vip_product'
		space:
			label: '商户'

		owner:
			label: '被分享人'

		share:
			label:'分享ID'
			type:'lookup'
			reference_to:'vip_share'

	list_views:
		all:
			label: "所有"
			columns: ["name","share","created"]
			filter_scope: "space"
	permission_set:
		user:
			allowCreate: true
			allowDelete: false
			allowEdit: true
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true
		admin:
			allowCreate: true
			allowDelete: false
			allowEdit: true
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true
		member:
			allowCreate: true
			allowDelete: false
			allowEdit: true
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true
		guest:
			allowCreate: true
			allowDelete: false
			allowEdit: true
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true
