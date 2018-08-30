Creator.Objects.surgery_records = 
	name: "surgery_records"
	icon: "contact"
	label: "手术记录"
	enable_search: true
	fields:
		name: 
			type: "lookup"
			label:"孩子姓名"
			reference_to: "care_records"
			group:'患者信息'

		cch: 
			type: "text"
			label:"孩子cch编号"
			required: true
			searchable:true
			index:true
			group:'患者信息'


		hospital:  	
			type: "text"
			label:"医院（Hospital）"
			searchable:true
			index:true
			group:'手术记录'

		surgery: 
			type: "text"
			label:"手术名称"
			searchable:true
			index:true
			group:'手术记录'

		surgery_type: 
			type: "select"
			label:"手术类别"
			searchable:true
			index:true
			options:[
				{label: "CCH-SH", value: "CCH-SH"},
				{label: "CCH-AC", value: "CCH-AC"},
				{label: "ST-CP", value: "ST-CP"}
			]
			group:'手术记录'

		surgery_date: 
			type: "date"
			label:"手术日期（Date of Surgery）"
			searchable:true
			index:true
			group:'手术记录'

		surgery_self_cost: 
			type: "number"
			label:"自费手术费"
			searchable:true
			index:true
			group:'手术记录'

		surgery_tp_cost: 
			type: "number"
			label:"TP手术费用"
			searchable:true
			index:true
			group:'手术记录'

		smile:  	
			type: "text"
			label:"微笑列车"
			searchable:true
			index:true
			group:'手术记录'

		others:  	
			type: "text"
			label:"其他机构"
			searchable:true
			index:true
			group:'手术记录'

		inpatient_record_number:  	
			type: "text"
			label:"住院病历号"
			searchable:true
			index:true
			group:'手术记录'
		
		tp_type: 
			type: "text"
			label:"TP类型"
			searchable:true
			index:true
			group:'其他'

		province: 
			type: "select"
			label:"省份"
			searchable:true
			index:true
			options:[
				{label: "北京", value: "北京"},
				{label: "上海", value: "上海"},
				{label: "天津", value: "天津"},
				{label: "重庆", value: "重庆"},
				{label: "辽宁", value: "辽宁"},
				{label: "吉林", value: "吉林"},
				{label: "黑龙江", value: "黑龙江"},
				{label: "河北", value: "河北"},
				{label: "山西", value: "山西"},
				{label: "陕西", value: "陕西"},
				{label: "山东", value: "山东"},
				{label: "安徽", value: "安徽"},
				{label: "江苏", value: "江苏"},
				{label: "浙江", value: "浙江"},
				{label: "河南", value: "河南"},
				{label: "湖北", value: "湖北"},
				{label: "湖南", value: "湖南"},
				{label: "江西", value: "江西"},
				{label: "台湾", value: "台湾"},
				{label: "福建", value: "福建"},
				{label: "云南", value: "云南"},
				{label: "海南", value: "海南"},
				{label: "四川", value: "四川"},
				{label: "贵州", value: "贵州"},
				{label: "广东", value: "广东"},
				{label: "甘肃", value: "甘肃"},
				{label: "青海", value: "青海"},
				{label: "西藏", value: "西藏"},
				{label: "新疆", value: "新疆"},
				{label: "广西", value: "广西"},
				{label: "内蒙古", value: "内蒙古"},
				{label: "宁夏", value: "宁夏"},
				{label: "香港", value: "香港"},
				{label: "澳门", value: "澳门"}
			]
			group:'其他'

		notes: 
			type: "textarea"
			label:"备注（Notes）"
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
			columns: ["name", "cch", "hospital","surgery","surgery_type", "surgery_date", "surgery_self_cost","surgery_tp_cost","smile", 
			"others","inpatient_record_number","tp_type", "province"]
			filter_scope: "space"

			# , "notes"
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
