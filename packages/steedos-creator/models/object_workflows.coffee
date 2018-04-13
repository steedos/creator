Creator.Objects.object_workflows =
	name: "object_workflows"
	label: "对象与流程对应关系"
	icon: "apps"
	fields:
		name:
			label: "名称"
			type: "text"
		object_name:
			label: "对象"
			type: "lookup"
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

	list_views:
		default:
			columns: ["name", "object_name", "flow_id"]
		all:
			label: "对象与流程对应关系"
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