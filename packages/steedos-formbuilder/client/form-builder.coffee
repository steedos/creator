Template.formBuilder.onRendered ()->
	console.log('formBuilder onRendered');

	options = {
		i18n: {
			locale: 'zh-CN'
		}
	};

	form = Creator.odata.get("forms", "72fc78f5b1747ba12e14a24c")

	formFields = form.current.fields

	fields = Creator.formBuilder.transformFormFieldsIn(formFields)

	options.typeUserAttrs = {
		text: {
			options: {
				label: "选项"
				type: 'textarea'
				placeholder: '选项1\r选项2\r选项3'
			},
			_id: {
				label: '唯一键'
				readonly: 'readonly'
			},
			is_wide: {
				label: '宽字段',
				value: false
				type: 'checkbox'
			},
			is_list_display: {
				label: '列表显示',
				value: false
				type: 'checkbox'
			},
			is_searchable: {
				label: '内容可搜',
				value: false
				type: 'checkbox'
			},
			formula: {
				label: '公式',
				type: 'textarea'
			}
		}
	}

	options.typeUserEvents = {
		text: {
			onadd: (fid)->
				$("input[type='textarea']",fid).each (_i, _element)->
					_id = $(_element).attr('id')
					_name = $(_element).attr('name')
					_class = $(_element).attr('class')
					_title = $(_element).attr('title')
					_placeholder = $(_element).attr('placeholder') || ''
					_value = $(_element).attr('value') || ''
					_rows =  $(_element).attr('rows') || 3
					textarea = $("<textarea id='#{_id}' name='#{_name}' class='#{_class}' title='#{_title}' placeholder='#{_placeholder}' rows='#{_rows}'>#{_value}</textarea>")
					$(_element).parent().append(textarea)
					$(_element).remove()
		}
	}

	options.typeUserDisabledAttrs = {
		'text': [
			'description',
			'maxlength',
			'placeholder'
		]
	}

	fb = $("#fb-editor").formBuilder(options)
	fb.promise.then (formBuilder)->
		formBuilder.actions.setData(fields)
		# fix bug: 第一个字段的typeUserAttrs不生效
		Meteor.setTimeout ()->
			formBuilder.actions.setData(fields)
		, 100
	window.fb = fb
