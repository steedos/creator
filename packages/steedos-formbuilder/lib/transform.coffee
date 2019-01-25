Creator.formBuilder = {}

Creator.formBuilder.transformFormFieldsIn = (formFields)->
	fields = []
	console.log('formFields', formFields)

	_.each formFields, (f)->
		field = _.extend({label: f.name || f.code, name: f.code, className: "form-control", value: f.default_value}, f)
		switch f.type
			when 'input'
				field.type = 'text'
				fields.push field
			when 'number'
				field.type = 'number'
				fields.push field
			when 'date'
				field.type = 'date'
				fields.push field
			when 'dateTime'
				console.log('TODO dateTime');
			when 'checkbox'
				console.log('TODO checkbox');
#				field.type = 'checkbox'
#				fields.push field
			when 'email'
				console.log('TODO email');
			when 'url'
				console.log('TODO url');
			when 'password'
				console.log('TODO password');
			when 'select'
				field.type = 'select'
				fields.push field
				console.log('TODO select');
			else
				console.log(f.code, f.name, f.type)

#		fields.push field

	return fields



Creator.formBuilder.transformFormFieldsOut = (fields)->
	console.log('');