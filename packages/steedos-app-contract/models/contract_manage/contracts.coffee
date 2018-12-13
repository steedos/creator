Creator.Objects.contracts = 
	name: "contracts"
	icon: "record"
	label: "合同信息"
	enable_search: true
	fields:
		_id:
			type:'text'
			label:"合同id"
		no:
			type:'text'
			label:"合同编号"
		name:
			type:"text"
			label:"合同名称"
			is_name:true
			required:true
			searchable:true
		project:
			type:'text'
			label:"计划编号"
		othercompany:
			type:'text'
			label:"对方单位名称"
		otherperson:
			type:'text'
			label:"对方联系人"
		isbidding:
			type:"boolean"
			label:"是否招投标"
			defaultValue:false
		contracttype:
			type: "lookup"
			label: "合同类型"
			reference_to: "contract_type"
			hidden: true
		startdate:
			type: "date"
			label: "开始时间"
		overdate:
			type: "date"
			label: "结束时间"
		contractamount:
			type:'currency'
			label:"合同金额"
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
			label:"质量比例"
		stampduty:
			type:'currency'
			label:"印花税额"
		contractstate:
			type: "lookup"
			label: "合同履行状态"
			reference_to: "contract_state"
		remarks:
			type:"text"
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
		singeddate:
			type: "datetime"
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
		shelfLife:
			type: "text"
			label: "质保期"
		Bsigned:
			type: "text"
			label: "对方签署人"
		Asigned:
			type: "text"
			label: "己方签署人"
		BoP:
			type: "select"
			label:"收支类别"
			defaultValue: "收入"
			options:[
				{label:"收入",value: "收入"},
				{label:"支出",value: "支出"}],
			allowedValues:["收入","支出"]
		subject:
			type: "text"
			label: "合同内容"
		isConnectedTransaction:
			type:"boolean"
			label:"是否关联交易"
			defaultValue: false
		isSolidInvestment:
			type:"boolean"
			label:"是否固投项目"
			defaultValue: false


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
	list_views:
		all:
			label:"全部"
			filter_scope: "space"
			columns:["no","name","othercompany","startdate","overdate","isbidding","contractamount","BoP","isConnectedTransaction","isSolidInvestment"]