Creator.Objects.object_workflows =
	name: "object_workflows"
	label: "对象流程"
	icon: "apps"
	fields:
		name:
			label: "名称"
			type: "text"
			required: true

		object_name:
			label: "对象"
			type: "master_detail"
			reference_to: "objects"
			required: true
			optionsFunction: ()->
				_options = []
				_.forEach Creator.objectsByName, (o, k)->
					_options.push {label: o.label, value: k, icon: o.icon}
				return _options

		flow_id:
			label: "流程"
			type: "lookup"
			required: true
			reference_to: "flows"

		field_map:
			label: "字段映射关系（对象至表单）"
			type: "grid"
			is_wide: true
			depend_on: ["object_name", "flow_id"]

		"field_map.$.object_field":
			label: "对象字段"
			type: "lookup"
			depend_on: ["object_name"]
			defaultIcon: "service_contract"
			optionsFunction: (values)->
				return Creator.getObjectLookupFieldOptions values?.object_name, true

		"field_map.$.workflow_field":
			label: "表单字段"
			type: "lookup"
			depend_on: ["flow_id"]
			optionsFunction: (values)->
				instance_fields = [{value:"name",label:"申请单名称"},
						{value:"submitter_name",label:"提交人姓名"},
						{value:"applicant_name",label:"申请人姓名"},
						{value:"applicant_organization_name",label:"申请人所属组织名称"},
						{value:"applicant_organization_fullname",label:"申请人所属组织全名"},
						{value:"state",label:"申请单状态"},
						{value:"current_step_name",label:"申请单当前步骤名称"},
						{value:"flow_name",label:"流程名称"},
						{value:"category_name",label:"分类名称"},
						{value:"submit_date",label:"提交时间"},
						{value:"finish_date",label:"结束时间"},
						{value:"final_decision",label:"最终意见"}
					]
				form_fields = []
				if values?.flow_id
					res_flow = Creator.odata.get("flows",values.flow_id,"form")
					if res_flow?.form
						form_id = res_flow?.form
						res_form = Creator.odata.get("forms",form_id,"current")
						if res_form?.current
							fields = res_form?.current.fields || []
							fields.forEach (f)->
								if f.type == 'section'
									if f.fields
										f.fields.forEach (ff)->
											form_fields.push {'label': ff.name || ff.code, 'value': ff.code}
								else
									form_fields.push {'label': f.name || f.code, 'value': f.code}

				options = _.union(instance_fields,form_fields)
				return options

		field_map_back:
			label: "字段映射关系（表单至对象）"
			type: "grid"
			is_wide: true
			depend_on: ["object_name", "flow_id"]

		"field_map_back.$.workflow_field":
			label: "表单字段"
			type: "lookup"
			depend_on: ["flow_id"]
			optionsFunction: (values)->
				instance_fields = [{value:"name",label:"申请单名称"},
						{value:"submitter_name",label:"提交人姓名"},
						{value:"applicant_name",label:"申请人姓名"},
						{value:"applicant_organization_name",label:"申请人所属组织名称"},
						{value:"applicant_organization_fullname",label:"申请人所属组织全名"},
						{value:"state",label:"申请单状态"},
						{value:"current_step_name",label:"申请单当前步骤名称"},
						{value:"flow_name",label:"流程名称"},
						{value:"category_name",label:"分类名称"},
						{value:"submit_date",label:"提交时间"},
						{value:"finish_date",label:"结束时间"},
						{value:"final_decision",label:"最终意见"}
					]
				form_fields = []
				if values?.flow_id
					res_flow = Creator.odata.get("flows",values.flow_id,"form")
					if res_flow?.form
						form_id = res_flow?.form
						res_form = Creator.odata.get("forms",form_id,"current")
						if res_form?.current
							fields = res_form?.current.fields || []
							fields.forEach (f)->
								if f.type == 'section'
									if f.fields
										f.fields.forEach (ff)->
											form_fields.push {'label': ff.name || ff.code, 'value': ff.code}
								else
									form_fields.push {'label': f.name || f.code, 'value': f.code}

				options = _.union(instance_fields,form_fields)
				return options

		"field_map_back.$.object_field":
			label: "对象字段"
			type: "lookup"
			depend_on: ["object_name"]
			defaultIcon: "service_contract"
			optionsFunction: (values)->
				return Creator.getObjectLookupFieldOptions values?.object_name, true


		sync_attachment:
			label: "附件同步方式"
			type: "select"
			options: "不同步:null,同步最新版本:lastest,同步所有版本:all"
			required: true

	list_views:
		default:
			columns: ["name", "object_name", "flow_id"]
		all:
			label: "全部"
			filter_scope: "space"
	permission_set:
		user:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true
		admin:
			allowCreate: true
			allowDelete: true
			allowEdit: true
			allowRead: true
			modifyAllRecords: true
			viewAllRecords: true