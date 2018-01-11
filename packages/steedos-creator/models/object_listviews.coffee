Creator.Objects.object_listviews = 
	name: "object_listviews"
	label: "视图"
	icon: "forecasts"
	fields: 
		name:
			type: "text"
		object_name: 
			type: "text"
			defaultValue: ->
				return Session.get "object_name"
		shared:
			type: "boolean"
		filters:
			type: "[Object]"
			omit: true
		"filters.$.field":
        	type: String
		"filters.$.operation":
        	type: String
		"filters.$.value":
        	type: String
		filter_logic:
			type: String
			omit: true
			
	list_views:
		default:
			columns: ["name", "shared", "modified"]
		all:
			filter_scope: "space"
