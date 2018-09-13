Creator.Objects.care_surgery_records = 
	name: "care_surgery_records"
	icon: "contact"
	label: "手术记录"
	enable_search: true
	fields:
		name: 
			type: "text"
			label:"手术名称"
			searchable:true
			required: true
			index:true

		username: 
			type: "master_detail"
			label:"cch编号和孩子姓名"
			reference_to: "care_medical_records"
			required: true

		hospital:  	
			type: "text"
			label:"医院（Hospital）"
			searchable:true
			index:true

		surgery_type: 
			type: "select"
			label:"手术类别"
			searchable:true
			index:true
			options: "CCH-SH,CCH-AC,ST-CP"

		surgery_date: 
			type: "date"
			label:"手术日期（Date of Surgery）"
			searchable:true
			index:true

		surgery_self_cost: 
			type: "number"
			label:"自费手术费"
			searchable:true
			index:true

		surgery_tp_cost: 
			type: "number"
			label:"TP手术费用"
			searchable:true
			index:true

		smile:  	
			type: "text"
			label:"微笑列车"
			searchable:true
			index:true

		others:  	
			type: "text"
			label:"其他机构"
			searchable:true
			index:true

		inpatient_record_number:  	
			type: "text"
			label:"住院病历号"
			searchable:true
			index:true
		
		tp_type: 
			type: "text"
			label:"TP类型"
			searchable:true

		province: 
			type: "select"
			label:"省份"
			searchable:true
			index:true
			options: "北京,上海,天津,重庆,辽宁,吉林,黑龙江,河北,山西,陕西,山东,安徽,江苏,浙江,河南,湖北,湖南,江西,台湾,福建,云南,海南,四川,贵州,广东,甘肃,青海,西藏,新疆,广西,内蒙古,宁夏,香港,澳门"

		notes: 
			type: "textarea"
			label:"备注（Notes）"
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
			columns: ["name", "username", "hospital","surgery","surgery_type", "surgery_date", "surgery_self_cost","surgery_tp_cost","smile", 
			"others","inpatient_record_number","tp_type", "province"]
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