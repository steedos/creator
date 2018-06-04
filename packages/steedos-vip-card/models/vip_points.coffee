Creator.Objects.vip_points =
	name: "vip_points"
	label: "积分"
	icon: "reward"
	fields:
		card:
			label:'会员卡'
			type:'lookup'
			reference_to:'vip_card'
		points:
			label:'积分'
			type:'number'
		location:
			label:'位置'
			type:'location'
		store:
			label:'门店'
			type:'lookup'
			reference_to:'vip_store'
		billing:
			label:'消费记录'
			type:'lookup'
			reference_to:'vip_billing'
	list_views:
		all:
			label: "我的积分记录"
			columns: ["card", "points", "billing","store"]
			filter_scope: "space"
	permission_set:
		user:
			allowCreate: false
			allowDelete: false
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