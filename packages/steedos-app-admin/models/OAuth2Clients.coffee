Creator.Objects.OAuth2Clients = 
	name: "OAuth2Clients"
	icon: "entity"
	label: "连接的应用程序"
	enable_search: false
	# db: Package["steedos:oauth2-server"]?.oAuth2Server?.collections?.clients
	fields: 
		clientName:
			type:"text"
			label:"名称"
			is_name:true
			required:true
		active:
			type:"boolean"
			label:"是否激活"
			defaultValue:true
		expires:
			type: "select"
			label:"有效期"
			defaultValue: "1H"
			options:[
				{label:"一小时",value:"1H"},
				{label:"永久",value:"YJ"}]
		redirectUri:
			type:"text"
			label:"回调URL"
			is_wide:true
			required:true
		clientId:
			type:"text"
			label:"客户端ID"
			is_wide:true
			defaultValue: ()->
				return Random.id()
		clientSecret:
			type:"text"
			label:"Secret"
			is_wide:true
			defaultValue: ()->
				return Random.secret()
		
	list_views:
		default:
			columns:["clientName","active","redirectUri"]
		all:
			label:"所有"
					
	permission_set:
		user:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: false
			modifyAllRecords: false
			viewAllRecords: false 
		admin:
			allowCreate: true
			allowDelete: true
			allowEdit: true
			allowRead: true
			modifyAllRecords: true
			viewAllRecords: true 