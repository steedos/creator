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

# Menu 支持两种类型的参数
# - template_name 指向 Meteor Template, url=/app/admin/_template/{template_name}/
# - object_name 指向对象, url=/app/admin/{object_name}/
Creator.Menus =  [

    { _id: 'account', name: 'Account' },
    { _id: 'account_password', name: 'Password', template_name: "account_password", parent: 'account' },
    { _id: 'account_background', name: 'Background', template_name: "account_background", parent: 'account' }

    { _id: 'users', name: 'Users' },
    { _id: 'users_organizations', name: 'Organizations', object_name: "organizations", parent: 'users' },
    { _id: 'users_users', name: 'Users', object_name: "users", parent: 'users' },

];