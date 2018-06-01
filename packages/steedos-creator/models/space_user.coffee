Creator.Objects.space_users = 
	name: "space_users"
	label: "人员"
	icon: "user"
	enable_search: true
	fields:
		name: 
			label: "名称"
			type: "text"
			defaultValue: ""
			description: ""
			inlineHelpText: ""
			required: true
			searchable:true
			index:true
		email:
			type: "text"
		user:
			type: "master_detail"
			reference_to: "users"
			# required: true
			omit: true
		position:
			type: "text"
		organization: 
			type: "master_detail"
			reference_to: "organizations"
			omit: true
		organizations:
			type: "lookup"
			reference_to: "organizations"
			multiple: true
			defaultValue: []
		manager:
			type: "lookup"
			reference_to: "users"
		sort_no:
			type: "number"
		user_accepted:
			type: "boolean"
			defaultValue: true
		invite_state:
			label: "邀请状态"
			type: "text"
			omit: true
		mobile:
			type: "text"
		work_phone:
			type: "text"
		position:
			type: "text"
		company:
			type: "text"
		phone:
			type:'[object]'
			label:'手机号信息'
			omit:true
		'phone.number':
			type:'text'
			omit:true
		'phone.mobile':
			type:'text'
			omit:true
		'phone.verified':
			type:'boolean'
			omit:true
			defaultValue:false
		'phone.modified':
			type:'datetime'
			omit:true
		profile:
			label: "用户身份"
			type: "select"
			defaultValue: "user"
			options: ()->
				return [{label: "员工", value: "user"}, {label: "会员", value: "member"}, {label: "游客", value: "guest"}]
	list_views:	
		user:
			label: "员工"
			columns: ["name", "organization", "position", "mobile", "email", "sort_no"]
			filter_scope: "space"
			filters: [["profile", "=", "user"]]
		member:
			label: "会员"
			columns: ["name", "mobile", "email", "sort_no"]
			filter_scope: "space"
			filters: [["profile", "=", "member"]]
		guest:
			label: "游客"
			columns: ["name",  "mobile", "email", "sort_no"]
			filter_scope: "space"
			filters: [["profile", "=", "guest"]]
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