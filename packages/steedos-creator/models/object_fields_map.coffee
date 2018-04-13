Creator.Objects.object_fields_map =
	name: "object_fields_map"
	label: "字段映射关系"
	icon: "apps"
	fields:
		ref:
			label: "对象与流程对应关系"
			type: "master_detail"
			required: true
			reference_to: "object_workflows"
		fields:
			label: "字段映射关系"
			type: "textarea"
			row: 8
			is_wide: true

	list_views:
		default:
			columns: ["ref", "fields"]
		all:
			label: "字段映射关系"
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