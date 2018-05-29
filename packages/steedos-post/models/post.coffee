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
		video:
			label: '视频'
			type: 'video'
			multiple : true
		audio:
			label: '音频'
			type: 'audio'
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
				{label:'优惠券',value:'coupon'},
				{label:'社区',value:'community'},
				{label:'红包',value:'red_packet'}
			]
		mini_type:
			label:'内容样式'
			type:'select'
			options:[
				{label:'文章',value:'article'},
				{label:'照片',value:'photo'},
				{label:'视频',value:'video'},
				{label:'音乐',value:'music'}
			]
	list_views:
		all:
			label: "所有信息"
			columns: ["name","summary", "comment_count", "star_count","forward_count"]
			filter_scope: "space"
		announcements:
			label:"公告"
			filter_scope:'space'
			filters: [["type", "=", "announcements"]]
		about:
			label:"关于"
			filter_scope:'space'
			filters: [["type", "=", "about"]]
		news:
			label:"新闻"
			filter_scope:'space'
			filters: [["type", "=", "news"]]
		help:
			label:"帮助"
			filter_scope:'space'
			filters: [["type", "=", "help"]]
		jobs:
			label:"招聘"
			filter_scope:'space'
			filters: [["type", "=", "jobs"]]
		course:
			label:"线上课程"
			filter_scope:'space'
			filters: [["type", "=", "course"]]
		coupon:
			label:"优惠卷"
			filter_scope:'space'
			filters: [["type", "=", "coupon"]]
		community:
			label:"社区"
			filter_scope:'space'
			filters: [["type", "=", "community"]]
		red_packet:
			label:'红包'
			filter_scope:'space'
			filters: [["type", "=", "red_packet"]]