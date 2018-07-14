Creator.Objects.vip_customers =
	name: "vip_customers"
	label: "客户"
	icon: "partners"
	fields:
		name:
			label: '姓名'
			type: 'text'

		from:
			label: '推荐人'
			type: 'lookup'
			reference_to: 'users'

		space:
			label: '商户'

		owner:
			label: '客户'

		mobile:
			type: "text"
			label:'手机'

		is_member:
			label: '是否会员'
			type: "boolean"

		share:
			label: '分享ID'
			type: 'lookup'
			reference_to: 'vip_share'

		balance:
			label: "余额"
			type: "number"
			defaultValue: 0
			scale: 2

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
