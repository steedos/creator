Creator.Objects.post =
	name: "post"
	label: "热点信息"
	icon: "apps"
	enable_files:true
	fields:
		name:
			label:'标题'
			type:'text'
			required:true
		summary:
			label:'简介'
			type:'text'
		description:
			label:'详细'
			is_wide:true
			type:'textarea'
		comment_count:
			label:'评论数'
			type:'number'
			omit:true
		star_count:
			label:'点赞数'
			type:'number'
			omit:true
		read_count:
			label:'阅读数'
			type:'number'
			omit:true
		forward_count:
			label:'转发数'
			type:'number'
			omit:true
		enable_comment:
			label:'是否允许评论'
			type:'boolean'
			defaultValue:true
		start_time:
			label:'开始时间'
			type:'datetime'
		end_time:
			label:'结束时间'
			type:'datetime'
		store:
			label:'门店'
			type:'master_detail'
			reference_to:'vip_store'
		images:
			label: '图片'
			type: 'image'
			multiple : true
		type:
			label:'所属分类'
			type:'select'
			options:[
				{label:'公告',value:'announcements'},
				{label:'关于',value:'about'},
				{label:'新闻',value:'news'},
				{label:'帮助',value:'help'},
				{label:'招聘',value:'jobs'},
				{label:'线上课程',value:'course'},
				{label:'优惠活动',value:'promotion'},
				{label:'社区',value:'community'}
			]
	list_views:
		all:
			label: "所有信息"
			columns: ["name","summary", "comment_count", "star_count","forward_count"]
			filter_scope: "space"