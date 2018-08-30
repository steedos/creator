Creator.Objects.care_records = 
	name: "care_records"
	icon: "contact"
	label: "医疗康复记录"
	enable_search: true
	fields:
		name: 
			type: "text"
			label:"孩子姓名"
			required: true
			searchable:true
			index:true
			group:'基本信息'

		cch: 
			type: "text"
			label:"孩子cch编号"
			required: true
			searchable:true
			index:true
			group:'基本信息'

		gender: 
			type: "select"
			label:"性别（Gender）"
			searchable:true
			index:true
			options:[
				{label: "男孩", value: "boy"},
				{label: "女孩", value: "girl"}
			]
			group:'基本信息'

		birthday: 
			type: "date"
			label:"生日（Date of Birth）"
			searchable:true
			index:true
			group:'基本信息'


		swi: 
			type: "text"
			label:"福利院中文（SWI）"
			searchable:true
			index:true
			group:'医疗记录'
		
		current_status: 
			type: "select"
			label:"孩子现状（Status）"
			searchable:true
			index:true
			options:[
				{label: "在关爱", value: "last"},
				{label: "在医院", value: "hospital"},
				{label: "回SWI", value: "SWI"},
				{label: "RIP", value: "RIP"}
			]	
			group:'医疗记录'

		cch_receiving: 
			type: "date"
			label:"cch接收日期"
			searchable:true
			index:true
			group:'医疗记录'

		cch_sickroom: 
			type: "text"
			label:"CCH病房"
			searchable:true
			index:true
			group:'医疗记录'

		cch_departure: 
			type: "date"
			label:"离开cch日期"
			searchable:true
			index:true
			group:'医疗记录'

		gone: 
			type: "date"
			label:"去世日期"
			searchable:true
			index:true
			group:'医疗记录'


		care_records:  	
			type: "textarea"
			label:"医疗康复记录（Care Records）"
			searchable:true
			index:true
			group:' '
			is_wide:true
			group:'医疗记录'

		disease: 
			type: "text"
			label:"疾病名称_中文"
			searchable:true
			index:true
			group:'医疗记录'

		surgeries: 
			type: "number"
			label:"手术次数（Number of surgeries）"
			searchable:true
			index:true
			group:'医疗记录'

		medical_condition: 
			type: "textarea"
			label:"medical condition"
			searchable:true
			index:true
			group:'医疗记录'


		reminders: 
			type: "textarea"
			label:"特别注意事项（Reminders）"
			searchable:true
			index:true
			group:'医疗记录'



		notes: 
			type: "textarea"
			label:"备注（Notes）"
			searchable:true
			index:true
			group:'其他'
		
		follow_up: 
			type: "textarea"
			label:"跟进情况（Follow-up）"
			searchable:true
			index:true
			group:'其他'

		photo_link: 
			type: "textarea"
			type: "text"
			label:"照片链接（Photo link）"
			searchable:true
			index:true
			group:'其他'
		
		owner:
			hidden:true
		

		# company:
		# 	type: "text",
		# 	label:"报送公司"
		# 	required: true
		# 	is_wide:true
		# 	searchable:true
		# 	index:true
		# 	defaultValue:()->
		# 		collection = Creator.Collections["space_users"]
		# 		company = collection.findOne({user:Meteor.userId(),space:Session.get("spaceId")},{fields:{company:1}}).company
		# 		return company
		# content:
		# 	type:"textarea",
		# 	rows: 8
		# 	label:"内容"
		# 	searchable:true
		# 	required: true
		# 	is_wide:true
		# score:
		# 	type:"number"
		# 	label:"分数"
		# 	omit:true
		# score_point:
		# 	type:"checkbox"
		# 	label:"得分点",
		# 	multiple:true
		# 	is_wide:true
		# 	options: [
		# 		{label: "上级采用", value: "上级采用"},
		# 		{label: "领导批示", value: "领导批示"},
		# 		{label: "正常使用", value: "正常使用"},
		# 		{label: "月度好信息", value: "月度好信息"},
		# 		{label:"专报信息",value:"专报信息"}
		# 	]

		# isuse:
		# 	type:"boolean"
		# 	label:"是否采用"
		# 	defaultValue:"否"
	list_views:
		all:
			label: "所有"
			columns: ["name", "cch", "gender","swi","current_status","cch_receiving", "cch_sickroom","cch_departure",
			"gone", "disease","surgeries"
			]
			# "birthday","care_record","medical_condition","reminders","notes", "follow_up","photo_link"
			filter_scope: "space"
	# 	recent:
	# 		label: "最近查看"
	# 		filter_scope: "space"
	# 	mine:
	# 		label: "我的上报信息"
	# 		filter_scope: "mine"
	# 	company:
	# 		label:"本公司上报信息"
	# 		filter_scope: "space"
	# 		filters: [["company", "=", "{user.company}"]]
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
	# triggers:
	# 	"before.insert.server.calculateScore": 
	# 		on: "server"
	# 		when: "before.insert"
	# 		todo: (userId, doc)->
	# 			doc.score = 0
	# 			if doc.score_point
	# 				doc.score_point.forEach (point)->
	# 					if point == "上级采用"
	# 						doc.score = doc.score + 10
	# 					else if point == '领导批示'
	# 						doc.score = doc.score + 10
	# 					else if point== '正常使用'
	# 						doc.score = doc.score + 5
	# 					else if point == '月度好信息'
	# 						doc.score = doc.score + 5
	# 					else if point == '专报信息'
	# 						doc.score = doc.score + 10
	# 			#Creator.baseObject.triggers['before.insert.server.default'].todo(userId,doc)			
					
	# 	"after.update.server.calculateScore": 
	# 		on: "server"
	# 		when: "after.update"
	# 		todo: (userId, doc)->
	# 			score = 0
	# 			if doc.score_point
	# 				doc.score_point.forEach (point)->
	# 					if point == "上级采用"
	# 						score = score + 10
	# 					else if point == '领导批示'
	# 						score = score + 10
	# 					else if point== '正常使用'
	# 						score = score + 5
	# 					else if point == '月度好信息'
	# 						score = score + 5
	# 					else if point == '专报信息'
	# 						score = score + 10
	# 			Creator.Collections['qhd_informations'].direct.update({_id:doc._id},{$set:{score:score}})
