Creator.Apps.crm = 
	url: "/app/crm"
	name: "合同"
	description: "合同录入、合同审批、应收应付、待办任务、统计分析"
	icon: "ion-ios-people-outline" 
	icon_slds: "account" 
	is_creator:true
	objects: ["contracts", "accounts", "contract_types", "contract_payments", "contract_receipts", "contacts", "tasks", "reports"]
	tabs: [
		{_id: 'steedos_chat_main', name: 'Chatter', template_name: 'steedos_chat_main'}
		{_id: 'contracts', name: '合同', object_name: 'contracts'}
		{_id: 'accounts', name: '单位', object_name: 'accounts'}
		{_id: 'contract_types', name: '合同分类', object_name: 'contract_types'}
		{_id: 'contract_payments', name: '付款', object_name: 'contract_payments'}
		{_id: 'contract_receipts', name: '收款', object_name: 'contract_receipts'}
		{_id: 'contacts', name: '联系人', object_name: 'contacts'}
		{_id: 'tasks', name: '任务', object_name: 'tasks'}
		{_id: 'reports', name: '报表', object_name: 'reports'}
	]

