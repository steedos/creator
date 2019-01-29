# 定义 formBuilder 所有的字段类型
FORMBUILDERFIELDTYPES = ["autocomplete", "paragraph", "header", "select",
	"checkbox-group", "radio-group", "checkbox", "text", "file",
	"date", "number", "textarea",
	"dateTime", "checkboxBoolean", "email", "url", "password", "user", "group",
	"table", "section"]

# 定义 禁用 的字段类型
DISABLEFIELDS = ['button','file','paragraph','autocomplete', 'hidden']

# 定义 禁用 的按钮
DISABLEDACTIONBUTTONS = ['clear','data','save']

# 定义 禁用 的字段属性
DISABLEDATTRS = ['description','maxlength','placeholder',"access","value",'min', 'max', 'step', 'inline', 'other', 'toggle', 'rows', 'subtype', 'multiple']

# 定义字段类型排序
CONTROLORDER = ['table', 'section', 'text','textarea','number','date','dateTime','date','checkboxBoolean','email','url','password','select','user','group',"radio-group","checkbox-group"]

# 获取各字段类型禁用的字段属性
#TYPEUSERDISABLEDATTRS = (()->
#	attrs = {}
#	_.each FORMBUILDERFIELDTYPES, (item)->
#		attrs[item] = DISABLEDATTRS
#		switch item
#			when 'number'
#				attrs[item] = attrs[item].concat(['min', 'max', 'step'])
#	return attrs
#)()

# 定义 通用的 字段属性
BASEUSERATTRS = {
	_id: {
		label: '唯一键'
		readonly: 'readonly'
	},
	value: {
		label: '默认值'
		type: 'text'
	},
	is_wide: {
		label: '宽字段',
		type: 'checkbox'
	},
	is_list_display: {
		label: '列表显示',
		type: 'checkbox'
	},
	is_searchable: {
		label: '内容可搜',
		type: 'checkbox'
	}
}

# 定义字段属性: 公式格式
FORMULAUSERATTRS = {
	formula: {
		label: '公式',
		type: 'textarea'
	}
}

# 定义字段属性：多选格式
MULTISELECTUSERATTRS = {
	is_multiselect: {
		label: '多选'
		value: false
		type: 'checkbox'
	}
}

# 获取各字段类型的属性
getTypeUserAttrs = ()->
	typeUserAttrs = {}
	_.each FORMBUILDERFIELDTYPES, (item)->
		switch item
			when 'select'
				typeUserAttrs[item] = _.extend {}, _.pick(BASEUSERATTRS, '_id', 'is_wide', 'is_list_display', 'is_searchable')
			when 'radio-group'
				typeUserAttrs[item] = _.extend {}, _.pick(BASEUSERATTRS, '_id', 'is_wide', 'is_list_display', 'is_searchable')
			when 'checkbox-group'
				typeUserAttrs[item] = _.extend {}, _.pick(BASEUSERATTRS, '_id', 'is_wide', 'is_list_display', 'is_searchable')
			when 'text'
				typeUserAttrs[item] = _.extend {
					options: {
						label: "选项"
						type: 'textarea'
						placeholder: '选项1\r选项2\r选项3'
					}
				}, BASEUSERATTRS, FORMULAUSERATTRS
			when 'number'
				typeUserAttrs[item] = _.extend {
					digits: {
						label: "小数位数"
						type: 'number'
						min: 0
					}
				}, BASEUSERATTRS, FORMULAUSERATTRS
			when 'password'
				typeUserAttrs[item] = {
					_id: {
						label: '唯一键'
						readonly: 'readonly'
					},
					is_wide: {
						label: '宽字段',
						value: false
						type: 'checkbox'
					}
				}
			when 'date'
				typeUserAttrs[item] = _.extend {}, BASEUSERATTRS
			when 'dateTime'
				typeUserAttrs[item] = _.extend {}, BASEUSERATTRS
			when 'checkboxBoolean'
				typeUserAttrs[item] = _.extend {}, BASEUSERATTRS
			when 'email'
				typeUserAttrs[item] = _.extend {}, BASEUSERATTRS
			when 'url'
				typeUserAttrs[item] = _.extend {}, BASEUSERATTRS
			when 'user'
				typeUserAttrs[item] = _.extend MULTISELECTUSERATTRS, BASEUSERATTRS
			when 'group'
				typeUserAttrs[item] = _.extend MULTISELECTUSERATTRS, BASEUSERATTRS
			when 'table'
				typeUserAttrs[item] =  {
					_id: {
						label: '唯一键'
						readonly: 'readonly'
					},
					description: {
						label: '描述',
						type: 'textarea'
					},
					fields: {
						label: '字段'
					}
				}
			when 'section'
				typeUserAttrs[item] =  {
					_id: {
						label: '唯一键'
						readonly: 'readonly'
					},
					description: {
						label: '描述',
						type: 'textarea'
					},
					fields: {
						label: '字段'
					}
				}
			else
				typeUserAttrs[item] = _.extend {}, BASEUSERATTRS, FORMULAUSERATTRS
	return typeUserAttrs

# 定义字段的事件
BASEUSEREVENTS = {
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
		$("input[type='checkbox']",fid).each (_i, _element)->
			if $(_element).val() == 'true'
				$(_element).attr('checked',true)
}
# 获取各字段类型的事件
getTypeUserEvents = ()->
	typeUserEvents = {}
	_.each FORMBUILDERFIELDTYPES, (item)->
		typeUserEvents[item] = BASEUSEREVENTS
	return typeUserEvents

# 定义扩展的字段类型
getFields = ()->
	[
		{
			label: "日期-时间",
			attrs: {
				type: 'dateTime'
			}
			icon: "⏲️"
		},
		{
			label: "勾选框"
			attrs: {
				type: "checkboxBoolean"
			}
			icon: "☑️"
		},
		{
			label: "邮件"
			attrs: {
				type: "email"
			}
			icon: "☑️"
		},
		{
			label: "网址"
			attrs: {
				type: "url"
			}
			icon: "☑️"
		},
		{
			label: "密码"
			attrs: {
				type: "password"
			}
			icon: "☑️"
		},
		{
			label: "选择用户"
			attrs: {
				type: "user"
			}
			icon: "👤"
		},
		{
			label: "选择部门"
			attrs: {
				type: "group"
			}
			icon: "👥"
		},
		{
			label: "表格"
			attrs: {
				type: "table"
			}
			icon: "😃"
		},
		{
			label: "分组"
			attrs: {
				type: "section"
			}
			icon: "😃"
		}
	]

# 定义扩展的字段显示模板
getFieldTemplates  = ()->
	{
		dateTime: (fieldData) ->
			if !fieldData.className
				fieldData.className = 'form-control'
			return {
				field: "<input id='#{fieldData.name}' type='datetime-local' #{Creator.formBuilder.utils.attrString(fieldData)}>",
			};
		checkboxBoolean: (fieldData)->
			return {
				field: "<input id='#{fieldData.name}' type='checkbox' #{Creator.formBuilder.utils.attrString(fieldData)}>",
			};
		email: (fieldData)->
			if !fieldData.className
				fieldData.className = 'form-control'
			return {
				field: "<input id='#{fieldData.name}' type='email' autocomplete='off' #{Creator.formBuilder.utils.attrString(fieldData)}>",
			};
		url: (fieldData)->
			if !fieldData.className
				fieldData.className = 'form-control'
			return {
				field: "<input id='#{fieldData.name}' type='url' autocomplete='off' #{Creator.formBuilder.utils.attrString(fieldData)}>",
			};
		password: (fieldData)->
			if !fieldData.className
				fieldData.className = 'form-control'
			return {
				field: "<input id='#{fieldData.name}' type='password' autocomplete='new-password' #{Creator.formBuilder.utils.attrString(fieldData)}>",
			};
		user: (fieldData)->
			if !fieldData.className
				fieldData.className = 'form-control'
			return {
				field: "<input id='#{fieldData.name}' type='text' readonly #{Creator.formBuilder.utils.attrString(fieldData)}>",
			};
		group: (fieldData)->
			if !fieldData.className
				fieldData.className = 'form-control'
			return {
				field: "<input id='#{fieldData.name}' type='text' readonly #{Creator.formBuilder.utils.attrString(fieldData)}>",
			};
		table: (fieldData)->
			delete fieldData.className
			return {
				field: "<div id='#{fieldData.name}' #{Creator.formBuilder.utils.attrString(fieldData)}></div>",
				onRender: ()->
					Meteor.setTimeout ()->
						tableFB = $("##{fieldData.name}").formBuilder(Creator.formBuilder.optionsForFormFields(true))
						if fieldData.fields
							tableFields = Creator.formBuilder.transformFormFieldsIn(JSON.parse(fieldData.fields))
							tableFB.promise.then (tableFormBuilder)->
								console.log('tableFields', tableFields)
								tableFormBuilder.actions.setData(tableFields)
								# fix bug: 第一个字段的typeUserAttrs不生效
								Meteor.setTimeout ()->
									tableFormBuilder.actions.setData(tableFields)
								, 100
					, 100
			};
		section: (fieldData)->
			delete fieldData.className
			return {
				field: "<div id='#{fieldData.name}' #{Creator.formBuilder.utils.attrString(fieldData)}></div>",
				onRender: ()->
					Meteor.setTimeout ()->
						sectionFB = $("##{fieldData.name}").formBuilder(Creator.formBuilder.optionsForFormFields(true))
						if fieldData.fields
							sectionFields = Creator.formBuilder.transformFormFieldsIn(JSON.parse(fieldData.fields))
							sectionFB.promise.then (sectionFormBuilder)->
								console.log('sectionFields', sectionFields)
								sectionFormBuilder.actions.setData(sectionFields)
								# fix bug: 第一个字段的typeUserAttrs不生效
								Meteor.setTimeout ()->
									sectionFormBuilder.actions.setData(sectionFields)
								, 100
				, 100
			};
	}

Creator.formBuilder.optionsForFormFields = (is_sub)->
	options = {
		i18n: {
			locale: 'zh-CN'
		},
		subtypes: {
			text: ['datetime-local']
		}
	};

	options.typeUserAttrs = getTypeUserAttrs()

	options.typeUserEvents = getTypeUserEvents()

#	options.typeUserDisabledAttrs = TYPEUSERDISABLEDATTRS

	options.disabledAttrs = DISABLEDATTRS

	disableFields = DISABLEFIELDS

	if is_sub
		disableFields.push 'table'
		disableFields.push 'section'

	options.disableFields = DISABLEFIELDS
	options.disabledActionButtons = DISABLEDACTIONBUTTONS

	options.fields = getFields()

	options.templates = getFieldTemplates()

	options.controlOrder = CONTROLORDER

	return options


Creator.formBuilder.forObjectFields = ()->
	console.log('Creator.formBuilder.forObjectFields')