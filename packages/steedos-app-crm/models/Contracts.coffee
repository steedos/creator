Creator.Objects.contracts =
	name: "contracts"
	label: "合同"
	icon: "contract"
	enable_files: true
	enable_search: true
	enable_tasks: true
	enable_notes: true
	enable_api: true
	fields:
		no:
			type:'text'
			label:"合同编号"
			required:true
			sortable:true
		name:
			label: "名称"
			type: "text"
			required: true
			searchable: true
			index: true
		amount:
			label: "金额"
			type: "currency"
			required: true
			sortable: true
		signed_date:
			label: "签订日期"
			type: "date"
			sortable: true
		owner:
			label: "责任人"
			omit: false
			sortable: true
		account:
			label: "对方单位"
			type: "master_detail"
			reference_to: "accounts"
		customer_contact:
			label: "联系人"
			type: "master_detail"
			reference_to: "contacts"
		start_date:
			label: "开始日期"
			type: "date"
			sortable: true
		end_date:
			label: "结束日期"
			type: "date"
			sortable: true
		description:
			label: "备注"
			type: "textarea"
			is_wide: true

		# 新增字段：所属单位，类似子管理员作分级权限。
		# 待处理：comapany拆分、分级权限。
		company_id:
			label: "承办单位"
			type: "lookup"
			reference_to: "organizations"
			sortable: true
			index:true
			is_company_only: true
			hidden: true


		subject:
			type: "textarea"
			label: "合同内容"
			is_wide: true
		project:
			type:'text'
			label:"计划编号"

		othercompany:
			type:'text'
			label:"对方单位名称"

		# 待处理：选择对方单位后，自动赋值registered_capital
		registered_capital:
			type: "currency"
			label: "注册资金"
			scale: 2
			hidden: true

		otherperson:
			type:'text'
			label:"对方联系人"

		# 新增字段：重大合同，
		# 待处理：按规则自动赋值
		is_important:
			type:"boolean"
			label:"重大合同"
			defaultValue:false

		is_bidding:
			type:"boolean"
			label:"是否招投标"
			defaultValue:false
		is_connected_transaction:
			type:"boolean"
			label:"是否关联交易"
			defaultValue: false
		is_solid_investment:
			type:"boolean"
			label:"是否固投项目"
			defaultValue: false
		contract_type:
			type: "lookup"
			label: "合同分类"
			reference_to: "contract_types"
			required:true

		# 按要求新增字段：合同税前金额。
		# 待处理：前后统一计，导入时，拟统一赋值为 合同金额。
		pretax_amount:
			type:'currency'
			label:"合同税前金额"
			scale: 2
		# 按要求新增字段：合同税。
		# 待处理：前后统一计，导入时，拟统一赋值为 0。
		tax:
			type:'currency'
			label:"合同税"
			scale: 2
		advance_amount:
			type:'currency'
			label:"预付款金额"
			scale: 2

		outstanding_amount:
			type:'currency'
			label:"未结金额"
			scale: 2

		# 待处理：修改质保比例，则自动赋值质量保证金；修改质量保证金，则自动赋值质保比例
		quality_bond:
			type:'currency'
			label:"质量保证金"
			scale: 2
		quality_proportion:
			type:'text'
			label:"质保比例"
		shelf_life:
			type: "text"
			label: "质保期"

		# 待处理:选择合同类型后，自动赋值yinhuashuilv
		yinhuashuilv:
			type: "number"
			label: "印花税率"
			scale: 4
		# 待处理:合同类型、合同税前金额复制后，自动赋值stamp_duty=pretax_amount*yinhuashuilv
		stamp_duty:
			type:'currency'
			label:"印花税额"
			scale: 2

		contract_state:
			type: "select"
			label: "合同履行状态"
			options:[
				{label:"未签订",value: "未签订"},
				{label:"进行中",value: "进行中"},
				{label:"解除",value: "解除"},
				{label:"异常",value: "异常"},
				{label:"已验收",value: "已验收"},
				{label:"完毕",value: "完毕"},
				{label:"违约但继续履行",value: "违约但继续履行"}],
			allowedValues:["未签订","进行中","解除","异常","完毕","违约但继续履行"]
			required:true

		fileid:
			type: "text"
			label: "申请单id"
			hidden: true
		chengbankeshi:
			type: "text"
			label: "承办科室"
		chengbanren:
			type: "text"
			label: "承办人"
		b_signed:
			type: "text"
			label: "对方签署人"
		a_signed:
			type: "text"
			label: "己方签署人"

		bop:
			type: "select"
			label:"收支类别"
			defaultValue: "收入"
			options:[
				{label:"收入",value: "收入"},
				{label:"支出",value: "支出"}],
			allowedValues:["收入","支出"]
			required:true

	list_views:
		recent:
			label: "最近查看"
			filter_scope: "space"
		all:
			label: "所有合同"
			columns: ["no", "name", "account", "company_id", "amount", "signed_date",  "contract_state"]
			filter_scope: "space"
		mine:
			label: "我的合同"
			filter_scope: "mine"

	permission_set:
		user:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: false
		admin:
			allowCreate: true
			allowDelete: true
			allowEdit: true
			allowRead: true
			modifyAllRecords: true
			viewAllRecords: true
		workflow_admin:
			allowCreate: true
			allowDelete: true
			allowEdit: true
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: false
			modifyCompanyRecords: true
			viewCompanyRecords: true
			disabled_list_views: []
			disabled_actions: []
			unreadable_fields: []
			uneditable_fields: []
			unrelated_objects: []