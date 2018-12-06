Creator.Apps.admin =
	url: "/app/admin"
	name: "设置"
	description: "系统管理员可以设置组织结构、人员、应用、权限等全局参数。"
	icon: "ion-ios-people-outline"
	icon_slds: "custom"
	is_creator:true
	objects: ["organizations", "space_users", "apps",
		"objects", "permission_set", "permission_shares",
		"application_package",
		"queue_import", "OAuth2Clients","OAuth2AccessTokens","categories"]
