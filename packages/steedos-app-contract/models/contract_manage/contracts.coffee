Creator.Objects.contracts = 
	name: "contracts"
	icon: "record"
	label: "合同信息"
	enable_search: true
	enable_files: true
	enable_tasks: true
	enable_instances: true
	enable_api: true
	enable_tree: true
	fields:
		company_id:
			label: "所属单位"
			type: "lookup"
			reference_to: "organizations"
			sortable: true
			index:true
			is_company_only: true
			hidden: true
		no:
			type:'text'
			label:"合同编号"
			required:true
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
		othercompany2:
			type: "lookup"
			label: "对方单位"
			reference_to: "contract_othercompany"
			required:true
		otherperson:
			type:'text'
			label:"对方联系人"			
		is3in1:
			type: "checkbox"
			label:"关联招标固投"
			options:[
				{label:"招投标",value: "招投标"},
				{label:"关联交易",value: "关联交易"},
				{label:"固投项目",value: "固投项目"}],
			allowedValues:["招投标","关联交易","固投项目"]
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
		startdate:
			type: "date"
			label: "开始时间"
		overdate:
			type: "date"
			label: "结束时间"
		contractamount:
			type:'currency'
			label:"合同金额"
			required:true
		pretaxamount:
			type:'currency'
			label:"合同税前金额"
		tax:
			type:'currency'
			label:"合同税"
		advanceamount:
			type:'currency'
			label:"预付款金额"
		outstandingamount:
			type:'currency'
			label:"未结金额"
		qualitybond:
			type:'currency'
			label:"质量保证金"
		qualityproportion:
			type:'text'
			label:"质保比例"
		stampduty:
			type:'currency'
			label:"印花税额"
		contractstate:
			type: "lookup"
			label: "合同履行状态"
			reference_to: "contract_state"
			required:true
		remarks:
			type:"textarea"
			label:"备注"
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
		company:
			type: "lookup"
			label: "承办单位"
			reference_to: "contract_company"
			required:true
		singeddate:
			type: "date"
			label: "合同签订日期"
		registeredcapital:
			type: "currency"
			label: "注册资金"
			hidden: true
		yinhuashuilv:
			type: "number"
			label: "印花税率"
		chengbankeshi:
			type: "text"
			label: "承办科室"
		chengbanren:
			type: "text"
			label: "承办人"
		fileid:
			type: "text"
			label: "申请单id"
			hidden: true
		shelfLife:
			type: "text"
			label: "质保期"
		Bsigned:
			type: "text"
			label: "对方签署人"
		Asigned:
			type: "text"
			label: "己方签署人"
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
		subject:
			type: "textarea"
			label: "合同内容"


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
			columns:["company","contracttype","no","project","name","othercompany","singeddate","startdate","overdate","isbidding","contractamount","is3in1","contractstate"]	