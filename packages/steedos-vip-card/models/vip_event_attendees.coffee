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
		wx_form_id:
			label:'表单'
			type:'text'
			omit:true
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
			modifyAllRecords: false
			viewAllRecords: true
	triggers:

		"before.insert.server.event":
			on: "server"
			when: "before.insert"
			todo: (userId, doc)->
				if _.isEmpty(doc.event)
					throw new Meteor.Error 500, "所属活动不能为空"
					
		"after.insert.server.event":
			on: "server"
			when: "after.insert"
			todo: (userId, doc)->
				status = doc.status
				if status
					collection = Creator.getCollection("vip_event")
					eventId = doc.event
					selector = {_id: eventId}
					# 增加记录时，如果status值存在，则应该在对应的事件中把status数量加一
					inc = {}
					inc["#{status}_count"] = 1
					collection.update(selector, {$inc: inc})
		
		"before.update.server.event":
			on: "server"
			when: "before.update"
			todo: (userId, doc)->
				if _.isEmpty(doc.event)
					throw new Meteor.Error 500, "所属活动不能为空"

		"after.update.server.event":
			on: "server"
			when: "after.update"
			todo: (userId, doc, fieldNames, modifier, options)->
				status = doc.status
				preStatus = this.previous.status
				if preStatus != status
					collection = Creator.getCollection("vip_event")
					eventId = doc.event
					selector = {_id: eventId}
					# 如果修改了status，则应该在对应的事件中把老的status数量减一，新的status数量加一
					inc = {}
					if preStatus
						inc["#{preStatus}_count"] = -1
					inc["#{status}_count"] = 1
					collection.update(selector, {$inc: inc})

		"after.remove.server.event":
			on: "server"
			when: "after.remove"
			todo: (userId, doc)->
				if _.isEmpty(doc.event)
					return
				status = doc.status
				if status
					collection = Creator.getCollection("vip_event")
					eventId = doc.event
					selector = {_id: eventId}
					# 删除记录时，如果status值存在，则应该在对应的事件中把status数量减一
					inc = {}
					inc["#{status}_count"] = -1
					collection.update(selector, {$inc: inc})