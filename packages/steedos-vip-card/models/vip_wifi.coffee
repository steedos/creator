Creator.Objects.vip_wifi =
	name: "vip_wifi"
	label: "Wifi"
	icon: "apps"
	fields:
		SSID:
			type:'text'
			label:'Wifi名称'
			is_name:true
			required:true
		BSSID:
			type:'text'
			label:'物理地址'
			required:true
		password:
			type:'text'
			label:'Wifi密码'
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
