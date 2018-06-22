Creator.Objects.vip_address =
	name: "vip_address"
	label: "收货地址"
	icon: "address"
	fields:
		name:
			label:'收货人'
			type:'text'
			required:true
		address:
			label:'地址'
			type:'location'
			required:true
		door:
			label:'门牌号'
			type:'text'
		gender:
			label:'性别'
			type:'select'
			options:[{label:"先生",value:'man'},{label:"女士",value:'woman'}]
		phone:
			label:'手机号'
			type:'text'
			required:true
		is_default:
			type:'boolean'
			label:'默认地址'
	list_views:
		all:
			label: "所有"
			columns: ["name", "address", "door", "phone", "is_default"]
			filter_scope: "space"
	permission_set:
		user:
			allowCreate: true
			allowDelete: true
			allowEdit: true
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
			allowEdit: true
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: false
		guest:
			allowCreate: true
			allowDelete: true
			allowEdit: true
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: false