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
		field = _.extend({
			label: f.name || f.code,
			className: "form-control",
			value: f.default_value,
			required: f.is_required
		}, f)
		switch f.type
			when 'input'
				field.type = 'text'
				if f.is_textarea
					field.type = 'textarea'
				fields.push field
			when 'number'
				if _.isNumber(field.digits)
					field.digits = field.digits.toString()
				field.type = 'number'
				fields.push field
			when 'date'
				field.type = 'dateNew'
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
	formFields = []
	_.each fields, (field)->
		_fieldName = field.name
		field.name = field.label
		field.is_required = field.required
		delete field.label
		delete field.className
		delete field.required
		delete field.value

		field.is_multiselect = field.is_multiselect || false
		field.is_searchable = field.is_searchable || false
		field.is_list_display = field.is_list_display || false
		field.is_wide = field.is_wide || false

		if _.isArray(field.values) && field.values.length > 0
			field.options = _.pluck(field.values, 'label').join('\n')
			if ['radio-group', 'select'].includes(field.type)
				field.default_value = (_.find field.values, (v)->
					return v.selected)?.label
			if ['checkbox-group'].includes(field.type)
				field.default_value = (_.pluck (_.filter field.values, (v)->
					return v.selected
				), 'label').join(',')

		delete field.values

		switch field.type
			when 'table'
				field.is_wide = true
				field.fields = Creator.formBuilder.transformFormFieldsOut($("##{_fieldName}-preview").data('formBuilder').actions.getData())
			when 'section'
				field.is_wide = true
				field.fields = Creator.formBuilder.transformFormFieldsOut($("##{_fieldName}-preview").data('formBuilder').actions.getData())
			when 'textarea'
				field.type = 'input'
				field.is_textarea = true
			when 'text'
				field.type = 'input'
			when 'checkboxBoolean'
				field.type = 'checkbox'
			when 'checkbox-group'
				field.type = 'multiSelect'
			when 'radio-group'
				field.type = 'radio'
			when 'number'
				field.digits = parseInt(field.digits)
			when 'dateNew'
				field.type = 'date'
		formFields.push field
	return formFields

Creator.formBuilder.validateForm = (form)->

Creator.formBuilder.getFieldsCode = (formFields)->
	fieldsCode = []
	fieldsCode = fieldsCode.concat(_.pluck(formFields, 'code'))
	subFields = _.filter formFields, (f)->
		return ['table','section'].includes(f.type)
	_.each subFields, (sf)->
		fieldsCode = fieldsCode.concat(Creator.formBuilder.getFieldsCode(sf.fields))
	return fieldsCode

Creator.formBuilder.validateFormFields = (fields)->
	fieldsCode = Creator.formBuilder.getFieldsCode(fields)
	validate = true
	_.each fields, (field)->
		try
			if !field.code
				throw new Meteor.Error('500', "请填写#{field.name}的字段名")

			if _.filter(fieldsCode, (fc)->
				fc == field.code
			).length > 1
				throw new Meteor.Error('500', "#{field.name}字段名重复")
			if ['table','section'].includes(field.type)
				Creator.formBuilder.validateFormFields field.fields
			Creator.formBuilder.validateForFmield field, fields

		catch e
			validate = false
			toastr.error(e.reason)
	return validate
Creator.formBuilder.validateForFmield = (field)->
	switch field.type
		when 'email'
			emailValid(field)
		when 'select'
			optionsValid(field)
		when 'multiSelect'
			optionsValid(field)
		when 'radio'
			optionsValid(field)
		when 'table'
			tableValid(field)
	return true

########private function#########
optionsValid = (field)->
	if !_.isString(field.options) || !field.options
		throw new Meteor.Error('500', "#{field.name}未设置选择项")

emailValid = (field)->
	if field.default_value
		reg = /^(\w)+(\.\w+)*@(\w)+((\.\w+)+)$/;
		if !reg.test(field.default_value)
			throw new Meteor.Error('500', "#{field.name}默认值不符合邮件地址的规则")

tableValid = (field)->
	if !_.isArray(field.fields) || field.fields.length == 0
		throw new Meteor.Error('500', "#{field.name}未设置列表字段")

#字段公式不是循环引用
hasFormulaFieldValid = (field, fields)->
	fields_has_formula = new Array()
	formula_codes = new Array()
	subForms = new Array()

	fields.reverse()

	_.each fields, (f)->
		if _.contains(['table', 'section'], f.type)

		else
			if f.formula
				fields_has_formula.push(f)
				formula_codes.push(f.code)



