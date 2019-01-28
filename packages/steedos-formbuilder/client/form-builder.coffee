###TODO###
# 1 国际化文件
# 2 分组

Template.formBuilder.onRendered ()->
	console.log('formBuilder onRendered');


	form = Creator.odata.get("forms", "aaca1cd8efa102b90f091b1e")

	formFields = form.current.fields

	fields = Creator.formBuilder.transformFormFieldsIn(formFields)

	options = Creator.formBuilder.optionsForFormFields()

	fb = $("#fb-editor").formBuilder(options)
	fb.promise.then (formBuilder)->
		formBuilder.actions.setData(fields)
		# fix bug: 第一个字段的typeUserAttrs不生效
		Meteor.setTimeout ()->
			formBuilder.actions.setData(fields)
		, 100
	window.fb = fb
