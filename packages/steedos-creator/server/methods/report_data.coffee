Meteor.methods
	'report_data': (options)->
		console.log "report_data,options:", options
		check(options, Object)
		space = options.space
		fields = options.fields
		object_name = options.object_name
		filterFields = {}
		compoundFields = []
		objectFields = Creator.getObject(object_name)?.fields
		_.each fields, (item, index)->
			console.log "each item:", item
			splits = item.split(".")
			name = splits[0]
			objectField = objectFields[name]
			console.log "each item, objectField:", objectField
			if splits.length > 1 and objectField
				childKey = item.replace name + ".", ""
				compoundFields.push({name: name, childKey: childKey, field: objectField})
			filterFields[name] = 1

		result = Creator.getCollection(object_name).find({space: space},fields: filterFields).fetch()
		console.log "compoundFields.length:", compoundFields.length
		if compoundFields.length
			return result.map (item,index)->
				_.each compoundFields, (compoundFieldItem, index)->
					itemKey = compoundFieldItem.name + "_" + compoundFieldItem.childKey.replace(/\./g, "_")
					itemValue = item[compoundFieldItem.name]
					switch compoundFieldItem.field.type
						when "lookup"
							reference_to = compoundFieldItem.field.reference_to
							console.log "compoundFields lookup.reference_to:", reference_to
							compoundFilterFields = {}
							compoundFilterFields[compoundFieldItem.childKey] = 1
							console.log "compoundFields lookup.reference_to._id:", item[compoundFieldItem.name]
							console.log "compoundFields lookup.reference_to.fields:", compoundFilterFields
							referenceItem = Creator.getCollection(reference_to).findOne {_id: itemValue}, fields: compoundFilterFields
							console.log "referenceItem:", referenceItem
							if referenceItem
								item[itemKey] = referenceItem[compoundFieldItem.childKey]
						when "master_detail"
							options = compoundFieldItem.field.options
						when "select"
							options = compoundFieldItem.field.options
							item[itemKey] = _.findWhere(options, {value: itemValue})?.label
						else
							item[itemKey] = itemValue
				return item
		else
			return result

