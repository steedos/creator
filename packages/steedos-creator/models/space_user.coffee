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
		profile:
			label: "用户身份"
			type: "select"
			defaultValue: "user"
			options: ()->
				return [{label: "员工", value: "user"}, {label: "会员", value: "member"}, {label: "游客", value: "guest"}]
	list_views:	
		all:
			label: "所有人员"
			columns: ["name", "organization", "position", "mobile", "email", "sort_no"]
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