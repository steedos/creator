set_contracttype2 = (doc)->
	contracttype2 = "买卖合同"
	Creator.Collections["contracts"].direct.update(doc._id,
	{
		$set:{
			contracttype2:contracttype2
		}
	})

Creator.Objects.contracts = 
	name: "contracts"
	icon: "record"
	label: "合同信息"
	enable_search: true
	enable_files: true
	enable_tasks: true
	enable_instances: true
	enable_api: true
	enable_tree: false
	fields:
		# 新增字段：所属单位，类似子管理员作分级权限。
		# 待处理：comapany拆分、分级权限。
		company_id:
			label: "所属单位"
			type: "lookup"
			reference_to: "organizations"
			sortable: true
			index:true
			is_company_only: true
			hidden: true
		company:
			type: "lookup"
			label: "承办单位"
			reference_to: "contract_company"
			required:true
		no:
			type:'text'
			label:"合同编号"
			required:true
			sortable:true
		name:
			type:"text"
			label:"合同名称"
			required:true
		project:
			type:'text'
			label:"计划编号"
		othercompany:
			type:'text'
			label:"对方单位名称"
		# 新增字段：对方单位，关联对方单位记录。原字段 对方单位名称 也保留，以利显示旧系统记录
		othercompany2:
			type: "lookup"
			label: "对方单位"
			reference_to: "contract_othercompany"
			required:true
		# 待处理：选择对方单位后，自动赋值registeredcapital	
		registeredcapital:
			type: "currency"
			label: "注册资金"
			scale: 2
			hidden: true
		otherperson:
			type:'text'
			label:"对方联系人"
		# 新增字段：重大合同，
		# 待处理：按规则自动赋值	
		isimportant:
			type:"boolean"
			label:"重大合同"
			defaultValue:false	
		# 本想将关联招标固投合成1个字段以利统计，但统计报表效果不佳，故维持字段分立	
		# is3in1:
		# 	type: "checkbox"
		# 	label:"关联招标固投"
		# 	options:[
		# 		{label:"招投标",value: "招投标"},
		# 		{label:"关联交易",value: "关联交易"},
		# 		{label:"固投项目",value: "固投项目"}],
		# 	allowedValues:["招投标","关联交易","固投项目"]
		isbidding:
			type:"boolean"
			label:"是否招投标"
			defaultValue:false
		isConnectedTransaction:
			type:"boolean"
			label:"是否关联交易"
			defaultValue: false
		isSolidInvestment:
			type:"boolean"
			label:"是否固投项目"
			defaultValue: false
		contracttype:
			type: "lookup"
			label: "合同类型"
			reference_to: "contract_type"
			required:true
		# 新增字段：合同统计类型，以利年度统计报表生成。如果年度统计报表改自动生成为定制开发，则此字段也可去掉。
		# 待处理:选择合同类型后，自动赋值：contracttype2
		contracttype2:
			type: "text"
			label: "合同统计类型"
			defaultValue: "其他合同"
#			omit: true
		singeddate:
			type: "date"
			label: "合同签订日期"
		startdate:
			type: "date"
			label: "开始时间"
		overdate:
			type: "date"
			label: "结束时间"
		contractamount:
			type:'currency'
			label:"合同金额"
			scale: 2
			required:true
		# 按要求新增字段：合同税前金额。
		# 待处理：前后统一计，导入时，拟统一赋值为 合同金额。
		pretaxamount:
			type:'currency'
			label:"合同税前金额"
			scale: 2
		# 按要求新增字段：合同税。
		# 待处理：前后统一计，导入时，拟统一赋值为 0。
		tax:
			type:'currency'
			label:"合同税"
			scale: 2
		advanceamount:
			type:'currency'
			label:"预付款金额"
			scale: 2
		outstandingamount:
			type:'currency'
			label:"未结金额"
			scale: 2
		# 待处理：修改质保比例，则自动赋值质量保证金；修改质量保证金，则自动赋值质保比例
		qualitybond:
			type:'currency'
			label:"质量保证金"
			scale: 2
		qualityproportion:
			type:'text'
			label:"质保比例"
		shelfLife:
			type: "text"
			label: "质保期"
		# 待处理:选择合同类型后，自动赋值yinhuashuilv
		yinhuashuilv:
			type: "number"
			label: "印花税率"
			scale: 4
		# 待处理:合同类型、合同税前金额复制后，自动赋值stampduty=pretaxamount*yinhuashuilv
		stampduty:
			type:'currency'
			label:"印花税额"
			scale: 2
		# contractstate 改为字符串、下拉取值，不关联contract_state
		# contractstate:
		# 	type: "lookup"
		# 	label: "合同履行状态"
		# 	reference_to: "contract_state"
		# 	required:true
		contractstate:
			type: "select"
			label: "合同履行状态"
			options:[
				{label:"未签订",value: "未签订"},
				{label:"进行中",value: "进行中"},
				{label:"解除",value: "解除"},
				{label:"异常",value: "异常"},
				{label:"完毕",value: "完毕"},
				{label:"违约但继续履行",value: "违约但继续履行"}],
			allowedValues:["未签订","进行中","解除","异常","完毕","违约但继续履行"]
			required:true
		subject:
			type: "textarea"
			label: "合同内容"
		remarks:
			type:"textarea"
			label:"备注"
		fileid:
			type: "text"
			label: "申请单id"
			hidden: true
		chengbankeshi:
			type: "text"
			label: "承办科室"
		# 待处理：选择 chengbanren2 后，自动赋值chengbanren
		chengbanren:
			type: "text"
			label: "承办人"	
		# 新增字段：承办人(选)
		chengbanren2:
			type: "lookup"
			label: "承办人(选)"
			reference_to: "space_users"
			is_company_only: true
		Bsigned:
			type: "text"
			label: "对方签署人"
		# 待处理：选择 Asigned2 后，自动赋值Asigned
		Asigned:
			type: "text"
			label: "己方签署人"
		# 新增字段：己方签署人(选)	
		Asigned2:
			type: "lookup"
			label: "己方签署人(选)"
			reference_to: "space_users"
			is_company_only: true
		BoP:
			type: "select"
			label:"收支类别"
			defaultValue: "收入"
			options:[
				{label:"收入",value: "收入"},
				{label:"支出",value: "支出"}],
			allowedValues:["收入","支出"]
			required:true
		created:
			type: "datetime"
			label: "创建时间"
		created_by:
			type: "text"
			label: "创建人"
			hidden: true
		modified:
			type: "datetime"
			label: "修改时间"
		modified_by:
			type: "text"
			label: "修改人"
			hidden: true


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
	list_views:
		all:
			label:"全部"
			filter_scope: "space"
			columns:["company","contracttype","no","project","name","othercompany","singeddate","startdate","overdate","isbidding","contractamount","is3in1","isimportant","contractstate"]	

	triggers:
		"after.insert.server.default":
			on: "server"
			when: "after.insert"
			todo: (userId, doc)->
				# 设置合同统计类别
				set_contracttype2(doc._id)

		"after.update.server.default":
			on: "server"
			when: "after.update"
			todo: (userId, doc)->
				# 设置合同统计类别
				set_contracttype2(doc._id)
		