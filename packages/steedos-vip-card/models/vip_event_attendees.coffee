Creator.Objects.vip_event_attendees =
	name: "vip_event_attendees"
	label: "活动参与者"
	icon: "event"
	fields:
		name:
			label:'姓名'
			type:'text'
			omit:true
		status:
			label:'接受状态'
			type:'select'
			options:[
				{label:'已接受',value:'accepted'},
				{label:'观望中',value:'pending'},
				{label:'已拒绝',value:'rejected'}
			]
		event:
			label:'活动名称'
			type:'lookup'
			reference_to:'vip_event'
			is_wide:true
			omit:true
		comment:
			label:'备注'
			type:'textarea'
			is_wide:true
		alarms:
			label:'提醒时间'
			type:'select'
			multiple:true
			options:[
				{label:'不提醒',value:'null'},
				{label:'活动开始时',value:'Now'},
				{label:'5分钟前',value:'-PT5M'},
				{label:'10分钟前',value:'-PT10M'},
				{label:'15分钟前',value:'-PT15M'},
				{label:'30分钟前',value:'-PT30M'},
				{label:'1小时前',value:'-PT1H'},
				{label:'2小时前',value:'-PT2H'},
				{label:'1天前',value:'-P1D'},
				{label:'2天前',value:'-P2D'}
			]
			group:'-'
	list_views:
		all:
			label: "所有参与者"
			columns: ["name","status"]
			filter_scope: "space"
	permission_set:
		user:
			allowCreate: true
			allowDelete: true
			allowEdit: true
			allowRead: true
			modifyAllRecords: true
			viewAllRecords: true
		admin:
			allowCreate: true
			allowDelete: true
			allowEdit: true
			allowRead: true
			modifyAllRecords: true
			viewAllRecords: true
		member:
			allowCreate: true
			allowDelete: true
			allowEdit: true
			allowRead: true
			modifyAllRecords: true
			viewAllRecords: true
		guest:
			allowCreate: true
			allowDelete: true
			allowEdit: true
			allowRead: true
			modifyAllRecords: true
			viewAllRecords: true