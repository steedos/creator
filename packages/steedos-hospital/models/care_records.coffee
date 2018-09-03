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

		reexamination_date: 
			type: "date"
			label:"复查时间"
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
			columns: ["name", "cch", "gender","swi","current_status","cch_receiving", "reexamination_date", "cch_sickroom","cch_departure",
			"gone", "disease","surgeries"]
			filter_scope: "space"

		week:
			label: "复查提醒（前一周）"
			columns: ["name", "cch", "gender","swi","current_status","cch_receiving", "reexamination_date", "cch_sickroom","cch_departure",
			"gone", "disease","surgeries"]
			filter_scope: "space"

		third:
			label: "复查提醒（前三天）"
			columns: ["name", "cch", "gender","swi","current_status","cch_receiving", "reexamination_date", "cch_sickroom","cch_departure",
			"gone", "disease","surgeries"]
			filter_scope: "space"

		first:
			label: "复查提醒（前一天）"
			columns: ["name", "cch", "gender","swi","current_status","cch_receiving", "reexamination_date", "cch_sickroom","cch_departure",
			"gone", "disease","surgeries"]
			filter_scope: "space"
	

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