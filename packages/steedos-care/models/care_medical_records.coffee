Creator.Objects.care_medical_records = 
	name: "care_medical_records"
	icon: "contact"
	label: "医疗康复记录"
	enable_search: true
	fields:
		name: 
			type: "text"
			label:"cch编号和孩子姓名"
			required: true
			searchable:true
			index:true

		gender: 
			type: "select"
			label:"性别（Gender）"
			index:true
			options: "男孩,女孩"

		birthday: 
			type: "date"
			label:"生日（Date of Birth）"
			searchable:true
			index:true

		nickname: 
			type: "text"
			label:"昵称"
			searchable:true

		photo: 
			type: "image"
			label:"头像"


		swi: 
			type: "text"
			label:"福利院中文（SWI）"
			searchable:true
		
		current_status: 
			type: "select"
			label:"孩子现状（Status）"
			searchable:true
			options: "在关爱,在医院,回SWI,RIP"	

		cch_receiving: 
			type: "date"
			label:"cch接收日期"

		cch_sickroom: 
			type: "text"
			label:"CCH病房"
			searchable:true
			index:true

		cch_departure: 
			type: "date"
			label:"离开cch日期"
			searchable:true
			index:true

		gone: 
			type: "date"
			label:"去世日期"
			searchable:true
			index:true


		care_records:  	
			type: "textarea"
			label:"医疗康复记录（Care Records）"
			searchable:true
			is_wide:true

		disease: 
			type: "text"
			label:"疾病名称_中文"
			searchable:true
			index:true

		reexamination_date: 
			type: "date"
			label:"复查时间"
			index:true

		reexamination_date_stamp: 
			type: "number"
			label:"复查时间"
			hidden:true
		
		surgeries: 
			type: "number"
			label:"手术次数（Number of surgeries）"
			searchable:true
			index:true

		medical_condition: 
			type: "textarea"
			label:"medical condition"



		reminders: 
			type: "textarea"
			label:"特别注意事项（Reminders）"
			searchable:true



		notes: 
			type: "textarea"
			label:"备注（Notes）"
			searchable:true
		
		follow_up: 
			type: "textarea"
			label:"跟进情况（Follow-up）"
			searchable:true

		
		owner:
			hidden:true

		created:
			hidden:true

		created_by:
			hidden:true

		modified:
			hidden:true
		
		modified_by:
			hidden:true
		
		
	list_views:
		all:
			label: "所有"
			columns: ["name", "gender","birthday","photo","nickname","swi","current_status","cch_receiving", "reexamination_date", "cch_sickroom","cch_departure",
			"gone", "disease","surgeries"]
			filter_scope: "space"

		week:
			label: "复查提醒（前一周）"
			columns: ["name", "gender","birthday","photo","nickname","swi","current_status","cch_receiving", "reexamination_date", "cch_sickroom","cch_departure",
			"gone", "disease","surgeries"]
			filter_scope: "space"
			filters: [{
				'field':"reexamination_date_stamp", 
				'operation':">=", 
				'value': ()->
					return new Date(new Date().toLocaleDateString()).getTime()
			}, 
			{	
				'field':"reexamination_date_stamp", 
				'operation':"<", 
				'value': ()->
					return new Date(new Date().toLocaleDateString()).getTime() +
						8* 24 * 60*60*1000
			}
			]

		third:
			label: "复查提醒（前三天）"
			columns: ["name", "gender","birthday","photo","nickname","swi","current_status","cch_receiving", "reexamination_date", "cch_sickroom","cch_departure",
			"gone", "disease","surgeries"]
			filter_scope: "space"
			filters: [{
				'field':"reexamination_date_stamp", 
				'operation':">=", 
				'value': ()->
					return new Date(new Date().toLocaleDateString()).getTime()
			}, 
			{	
				'field':"reexamination_date_stamp", 
				'operation':"<", 
				'value': ()->
					return new Date(new Date().toLocaleDateString()).getTime() +
						4* 24 * 60*60*1000
			}
			]
		
		first:
			label: "复查提醒（前一天）"
			columns: ["name", "gender","birthday","photo","nickname","swi","current_status","cch_receiving", "reexamination_date", "cch_sickroom","cch_departure",
			"gone", "disease","surgeries"]
			filter_scope: "space"
			filters: [{
				'field':"reexamination_date_stamp", 
				'operation':">=", 
				'value': ()->
					return new Date(new Date().toLocaleDateString()).getTime()
			}, 
			{	
				'field':"reexamination_date_stamp", 
				'operation':"<", 
				'value': ()->
					return new Date(new Date().toLocaleDateString()).getTime() +
						2* 24 * 60*60*1000
			}
			]

	triggers:
		"before.insert.server.care_records":
			on: "server"
			when: "before.insert"
			todo: (userId, doc)->
				if doc.reexamination_date
					doc.reexamination_date_stamp = doc.reexamination_date.getTime()
		"before.update.server.care_records":
			on: "server"
			when: "before.update"
			todo: (userId, doc, fieldNames, modifier, options)->
				if modifier?.$set?.reexamination_date
						modifier.$set.reexamination_date_stamp = modifier.$set.reexamination_date.getTime()
	
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