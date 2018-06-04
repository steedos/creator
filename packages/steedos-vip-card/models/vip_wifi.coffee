Creator.Objects.vip_wifi =
	name: "vip_wifi"
	label: "Wi-Fi"
	icon: "topic"
	fields:
		SSID:
			type:'text'
			label:'Wi-Fi名称'
			is_name:true
			required:true
		BSSID:
			type:'text'
			label:'物理地址'
			required:true
		password:
			type:'text'
			label:'Wi-Fi密码'
		store:
			label:'门店'
			type:'lookup'
			reference_to:'vip_store'
			required:true
	list_views:
		all:
			label: "所有Wifi"
			columns: ["SSID", "BSSID", "password", "store"]
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
		guest:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true
		member:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true