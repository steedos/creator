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

Creator.Menus =  [
    { _id: 'profile', name: 'Profile' },
    { _id: 'profile_password', name: 'Password', template_name: "profile_password", parent: 'profile' },
    { _id: 'profile_background', name: 'Background', template_name: "profile_background", parent: '2' }
    { _id: 'users', name: 'Users' },
    { _id: 'users_organizations', name: 'Organizations', object_name: "organizations", parent: 'users' },
    { _id: 'users_users', name: 'Users', object_name: "users", parent: 'users' },
];