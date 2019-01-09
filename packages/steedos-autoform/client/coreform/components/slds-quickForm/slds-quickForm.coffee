Template.quickForm_slds.helpers
	fieldGroupLabel: ->
		name = @name
		# if field group name is of the form XY_abcde where "XY" is a number, remove prefix
		if !isNaN(parseInt(name.substr(0, 2), 10)) and name.charAt(2) == '_'
			name = name.substr(3)
		# if SimpleSchema.defaultLabel is defined, use it
		if typeof SimpleSchema.defaultLabel == 'function'
			SimpleSchema.defaultLabel name
		else
			name.charAt(0).toUpperCase() + name.slice(1)
	quickFieldsAtts: ->
		_.pick Template.instance().data.atts, 'fields', 'id-prefix', 'input-col-class', 'label-class'

	quickFieldAtts: ->
		afQuickFieldsComponentAtts = undefined
		defaultOptions = undefined
		atts = {}
		afQuickFieldsComponentAtts = Template.parentData(1)
		if !afQuickFieldsComponentAtts or afQuickFieldsComponentAtts.atts
			afQuickFieldsComponentAtts = {}
		defaultOptions = AutoForm._getOptionsForField(this)
		if defaultOptions
			atts.options = defaultOptions
		_.extend {name: this}, atts, afQuickFieldsComponentAtts

	submitButtonAtts: ->
		qfAtts = @atts
		atts = {}
		if typeof qfAtts.buttonClasses == 'string'
			atts['class'] = qfAtts.buttonClasses
		else
			atts['class'] = 'btn btn-primary'
		atts

	isDisabled: (key)->
		object_name = Template.instance().data.atts.object_name
		fields = Creator.getObject(object_name)?.fields
		return fields[key]?.disabled
	hasInlineHelpText: (key)->
		object_name = Template.instance().data.atts.object_name
		fields = Creator.getObject(object_name)?.fields
		return fields[key]?.inlineHelpText

	is_range: (key)->
		return Template.instance()?.data?.qfAutoFormContext.schema._schema[key]?.autoform?.is_range

	schemaFields: ()->
		object_name = this.atts.object_name
		object = Creator.getObject(object_name)
		keys = []
		if object
			schemaInstance = this.qfAutoFormContext.schema
			schema = schemaInstance._schema

			firstLevelKeys = schemaInstance._firstLevelSchemaKeys
			permission_fields = this.qfAutoFormContext.fields || firstLevelKeys

			unless permission_fields
				permission_fields = []

			_.each schema, (value, key) ->
				if (_.indexOf firstLevelKeys, key) > -1
					if !value.autoform?.omit
						keys.push key

			if keys.length == 1
				finalFields =
					grouplessFields: [keys]
				return finalFields

			hiddenFields = Creator.getHiddenFields(schema)
			disabledFields = Creator.getDisabledFields(schema)

			fieldGroups = []
			fieldsForGroup = []
			isSingle = Session.get "cmEditSingleField"

			grouplessFields = []
			grouplessFields = Creator.getFieldsWithNoGroup(schema)
			grouplessFields = Creator.getFieldsInFirstLevel(firstLevelKeys, grouplessFields)
			if permission_fields
				grouplessFields = _.intersection(permission_fields, grouplessFields)
			grouplessFields = Creator.getFieldsWithoutOmit(schema, grouplessFields)
			grouplessFields = Creator.getFieldsForReorder(schema, grouplessFields, isSingle)

			fieldGroupNames = Creator.getSortedFieldGroupNames(schema)
			_.each fieldGroupNames, (fieldGroupName) ->
				fieldsForGroup = Creator.getFieldsForGroup(schema, fieldGroupName)
				fieldsForGroup = Creator.getFieldsInFirstLevel(firstLevelKeys, fieldsForGroup)
				if permission_fields
					fieldsForGroup = _.intersection(permission_fields, fieldsForGroup)
				fieldsForGroup = Creator.getFieldsWithoutOmit(schema, fieldsForGroup)
				fieldsForGroup = Creator.getFieldsForReorder(schema, fieldsForGroup, isSingle)
				fieldGroups.push
					name: fieldGroupName
					fields: fieldsForGroup

			finalFields =
				grouplessFields: grouplessFields
				groupFields: fieldGroups
				hiddenFields: hiddenFields
				disabledFields: disabledFields

			return finalFields


Template.quickForm_slds.events
	'click .group-section-control': (event, template) ->
		event.preventDefault()
		event.stopPropagation()
		$(event.currentTarget).closest('.group-section').toggleClass('slds-is-open')