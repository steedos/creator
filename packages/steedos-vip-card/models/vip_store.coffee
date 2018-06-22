Creator.Objects.vip_store =
	name: "vip_store"
	label: "门店"
	icon: "address"
	fields:
		name:
			label:'名称'
			type:'text'
			is_wide:true
		description:
			label:'简介'
			type:'textarea'
			is_wide:true
		
		location:
			label:'位置'
			type:'location'
			group:'-'
		# contact:
		# 	type:'lookup'
		# 	reference_to:'users'
		# 	label:'联系人'
		phone:
			type:'phone'
			label:'联系电话'
		business_hours:
			type:'text'
			label:'营业时间'
		# address:
		# 	type:'text'
		# 	label:'地址'
		# merchant:
		# 	type:'text'
		# 	label:'所属商户'
		# 	hidden:true
		avatar:
			label:'头像'
			type:'image'
			group:'-'
		cover:
			label:'封面照片'
			type:'image'
		qrcode:
			label:'二维码'
			type:'image'
			#readonly:true
		enabled_objects:
			label:'启用功能'
			type:'select'
			options:[
				{label:'会员卡',value:'vip_card'},
				{label:'最新动态',value:'post'},
				{label:'活动报名',value:'vip_activity'},
				{label:'Wifi',value:'vip_wifi'},
				{label:'在线客服', value:'support'}
				{label:'联系我们',value:'vip_store'}
			]
			multiple:true
			group:'-'
		featured:
			label:'发布到首页'
			type:'boolean'
			group:'-'
		star_count:
			label:'关注人数'
			type:'number'
			readonly:true
			omit:true
		# post_types:
		# 	label:'信息分类'
		# 	type:'select'
		# 	options:[
		# 		{label:'公告通知',value:'announcements'},
		# 		{label:'关于我们',value:'about'},
		# 		{label:'新闻动态',value:'news'},
		# 		{label:'会员指南',value:'help'},
		# 		{label:'招兵买马',value:'jobs'},
		# 		{label:'线上课程',value:'course'},
		# 		# {label:'优惠券',value:'coupon'},
		# 		# {label:'社区',value:'community'},
		# 		# {label:'红包',value:'red_packet'}
		# 	]
		# 	multiple:true
		# mch_id:
		# 	type: 'text'
		# 	label: '商户号'
		# 	# required: true
	list_views:
		all:
			label: "所有"
			columns: ["name", "location", "phone","address","business_hours","merchant"]
			filter_scope: "space"
	triggers:
		"before.insert.server.store":
			on: "server"
			when: "before.insert"
			todo: (userId, doc)->
		"before.update.server.store":
			on: "server"
			when: "before.update"
			todo: (userId, doc, fieldNames, modifier, options)->
		"after.insert.server.store":
			todo: (userId, doc)->
				space_doc = {avatar:doc.avatar,cover:doc.cover,name:doc.name}
				if doc._id == doc.space
					Creator.getCollection("spaces").direct.update({_id: doc.space}, {$set:space_doc})

		"after.update.server.store":
			on: "server"
			when: "after.update"
			todo: (userId, doc, fieldNames, modifier, options)->
				space_doc = {avatar:doc.avatar,cover:doc.cover}
				if doc._id == doc.space
					if modifier?.$set?.name
						space_doc['name'] = modifier.$set.name
					Creator.getCollection("spaces").direct.update({_id: doc.space}, {$set: space_doc})
				if modifier?.$set?.avatar
					Creator.getCollection("vip_store").direct.update({_id: doc.space},{$unset:{qrcode:1}})					
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
			allowDelete: false
			allowEdit: true
			allowRead: true
			modifyAllRecords: false
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