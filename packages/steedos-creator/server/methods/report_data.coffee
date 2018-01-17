Meteor.methods
	'report_data': (options)->
		check(options, Object)
		space = options.space
		fields = options.fields
		object_name = options.object_name
		filterFields = {}
		compoundFields = []
		objectFields = Creator.getObject(object_name)?.fields
		_.each fields, (item, index)->
			splits = item.split(".")
			name = splits[0]
			objectField = objectFields[name]
			if splits.length > 1 and objectField
				childKey = item.replace name + ".", ""
				compoundFields.push({name: name, childKey: childKey, field: objectField})
			filterFields[name] = 1

		result = Creator.getCollection(object_name).find({space: space},fields: filterFields).fetch()
		if compoundFields.length
			return result.map (item,index)->
				_.each compoundFields, (compoundFieldItem, index)->
					itemKey = compoundFieldItem.name + "_" + compoundFieldItem.childKey.replace(/\./g, "_")
					itemValue = item[compoundFieldItem.name]
					type = compoundFieldItem.field.type
					if ["lookup", "master_detail"].indexOf(type) > -1
						reference_to = compoundFieldItem.field.reference_to
						compoundFilterFields = {}
						compoundFilterFields[compoundFieldItem.childKey] = 1
						referenceItem = Creator.getCollection(reference_to).findOne {_id: itemValue}, fields: compoundFilterFields
						if referenceItem
							item[itemKey] = referenceItem[compoundFieldItem.childKey]
					else if type == "select"
						options = compoundFieldItem.field.options
						item[itemKey] = _.findWhere(options, {value: itemValue})?.label or itemValue
					else
						item[itemKey] = itemValue
				return item
		else
			return result

