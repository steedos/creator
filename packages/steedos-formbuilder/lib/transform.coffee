getFormFieldOptions = (field)->
	options = field.options.split('\n');
	values = []
	_.each options, (option)->
		if option == field.default_value
			values.push {label: option, value: option, selected: true}
		else
			values.push {label: option, value: option}
	return values

Creator.formBuilder.transformFormFieldsIn = (formFields)->
	fields = []
	_.each formFields, (f)->
		field = _.extend({label: f.name || f.code, name: f.code, className: "form-control", value: f.default_value}, f)
		switch f.type
			when 'input'
				field.type = 'text'
				if f.is_textarea
					field.type = 'textarea'
				fields.push field
			when 'number'
				field.type = 'number'
				fields.push field
			when 'date'
				field.type = 'date'
				fields.push field
			when 'dateTime'
				field.type = 'dateTime'
				fields.push field
			when 'checkbox'
				#TODO 默认值 boolean
				field.type = 'checkboxBoolean'
				delete field.className
				fields.push field
			when 'email'
				field.type = 'email'
				fields.push field
			when 'url'
				field.type = 'url'
				fields.push field
			when 'password'
				field.type = 'password'
				fields.push field
			when 'select'
				field.type = 'select'
				field.values = getFormFieldOptions(f)
				delete field.options
				fields.push field
			when 'user'
				field.type = 'user'
				fields.push field
			when 'group'
				field.type = 'group'
				fields.push field
			when 'radio'
				field.type = 'radio-group'
				field.values = getFormFieldOptions(f)
				delete field.options
				delete field.className
				fields.push field
			when 'multiSelect'
				field.type = 'checkbox-group'
				field.values = getFormFieldOptions(f)
				delete field.options
				delete field.className
				fields.push field
			when 'table'
				field.type = 'table'
				field.fields = JSON.stringify(field.fields)
				delete field.className
				fields.push field
			when 'section'
				field.type = 'section'
				field.fields = JSON.stringify(field.fields)
				delete field.className
				fields.push field
			else
				console.log(f.code, f.name, f.type)

#		fields.push field

	return fields



Creator.formBuilder.transformFormFieldsOut = (fields)->
	console.log('');