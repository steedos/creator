Template.creator_report.helpers
	reportObject: ->
		record_id = Session.get "record_id"
		return Creator.Reports[record_id] or Creator.getObjectRecord()

	actions: ()->
		obj = Creator.getObject()
		object_name = obj.name
		record_id = Session.get "record_id"
		permissions = obj.permissions.get()
		actions = _.values(obj.actions) 
		# actions = _.where(actions, {on: "record", visible: true})
		actions = _.filter actions, (action)->
			if action.on == "record"
				if action.only_list_item
					return false
				if typeof action.visible == "function"
					return action.visible(object_name, record_id, permissions)
				else
					return action.visible
			else
				return false
		return actions

	moreActions: ()->
		obj = Creator.getObject()
		object_name = obj.name
		record_id = Session.get "record_id"
		permissions = obj.permissions.get()
		actions = _.values(obj.actions) 
		actions = _.filter actions, (action)->
			if action.on == "record_more"
				if action.only_list_item
					return false
				if typeof action.visible == "function"
					return action.visible(object_name, record_id, permissions)
				else
					return action.visible
			else
				return false
		return actions

	showFilterOption: ()->
		return Session.get("show_filter_option")

	filterLeft: ()->
		return Template.instance().filter_PLeft?.get()

	filterTop: ()->
		return Template.instance().filter_PTop?.get()

	filterIndex: ()->
		return Template.instance().filter_index?.get()
	
	filterItems: ()->
		return Session.get("filter_items")

	filterItem: ()->
		debugger
		index = Template.instance().filter_index?.get()
		filter_items = Session.get("filter_items")
		if index > -1 and filter_items
			return filter_items[index]

	isEditScope: ()->
		return Template.instance().is_edit_scope?.get()

Template.creator_report.events

	'click .record-action-custom': (event, template) ->
		id = Creator.getObjectRecord()._id
		objectName = Session.get("object_name")
		object = Creator.getObject(objectName)
		collection_name = object.label
		Session.set("action_fields", undefined)
		Session.set("action_collection", "Creator.Collections.#{objectName}")
		Session.set("action_collection_name", collection_name)
		Session.set("action_save_and_insert", true)
		Creator.executeAction objectName, this, id

	'click .btn-filter-scope': (event, template)->
		template.is_edit_scope.set(true)

		left = $(event.currentTarget).closest(".filter-list-container").offset().left
		# top = $(event.currentTarget).closest(".slds-item").offset().top
		top = $(event.currentTarget).closest(".reportsFilterCard").offset().top

		# offsetLeft = $(event.currentTarget).closest(".slds-template__container").offset().left
		# offsetTop = $(event.currentTarget).closest(".slds-template__container").offset().top
		# contentHeight = $(event.currentTarget).closest(".slds-item").height()
		offsetLeft = $(event.currentTarget).closest(".pageBody").offset().left
		offsetTop = $(event.currentTarget).closest(".pageBody").offset().top
		contentHeight = $(event.currentTarget).closest(".reportsFilterCard").height()

		# 弹出框的高度和宽度写死
		left = left - offsetLeft - 400 - 6
		top = top - offsetTop - 170/2 + contentHeight/2

		Session.set("show_filter_option", false)
		Tracker.afterFlush ->
			Session.set("show_filter_option", true)
			template.filter_PLeft.set("#{left}px")
			template.filter_PTop.set("#{top}px")
	
	'click .filter-option-item': (event, template)->
		template.is_edit_scope.set(false)

		index = $(event.currentTarget).closest(".filter-item").index() - 1
		if index < 0
			index = 0

		left = $(event.currentTarget).closest(".filter-list-container").offset().left
		top = $(event.currentTarget).closest(".reportsFilterCard").offset().top
		contentHeight = $(event.currentTarget).closest(".reportsFilterCard").height()

		offsetLeft = $(event.currentTarget).closest(".pageBody").offset().left
		offsetTop = $(event.currentTarget).closest(".pageBody").offset().top

		# 弹出框的高度和宽度写死
		left = left - offsetLeft - 400 - 6
		top = top - offsetTop - 336/2 + contentHeight/2

		# 计算弹出框是否超出屏幕底部，导致出现滚动条，如果超出，调整top位置
		# 计算方式：屏幕高度 - 弹出框的绝对定位 - 弹出框的高度 - 弹出框父容器position:relative的offsetTop - 弹出框距离屏幕底部10px
		# 如果计算得出值小于0，则调整top，相应上调超出的高度
		windowHeight = $(window).height()
		windowOffset = $(window).height() - top - 336 - offsetTop - 10

		if windowOffset < 0
			top = top + windowOffset

		Session.set("show_filter_option", false)

		Tracker.afterFlush ->
			Session.set("show_filter_option", true)
			template.filter_index.set(index)
			template.filter_PLeft.set("#{left}px")
			template.filter_PTop.set("#{top}px")


renderTabularReport = (reportObject, spaceId)->
	objectName = reportObject.object_name
	objectFields = Creator.getObject(objectName)?.fields
	if _.isEmpty objectFields
		return
	filterFields = reportObject.columns
	filter_scope = reportObject.filter_scope || "space"
	filters = reportObject.filters
	Meteor.call "report_data",{object_name: objectName, space: spaceId, filter_scope: filter_scope, filters: filters, fields: filterFields}, (error, result)->
		if error
			console.error('report_data method error:', error)
			return
		
		reportColumns = reportObject.columns?.map (item, index)->
			itemFieldKey = item.replace(/\./g,"_")
			itemField = objectFields[item.split(".")[0]]
			return {
				caption: itemField.label
				dataField: itemFieldKey
			}
		unless reportColumns
			reportColumns = []
		reportData = result
		pivotGrid = $('#pivotgrid').dxDataGrid(
			dataSource: reportData
			paging: false
			columns: reportColumns).dxDataGrid('instance')
		return

renderSummaryReport = (reportObject, spaceId)->
	objectName = reportObject.object_name
	objectFields = Creator.getObject(objectName)?.fields
	if _.isEmpty objectFields
		return
	filterValueFields = reportObject.values?.map (item, index)->
		return item.field
	filterFields = _.union reportObject.columns, reportObject.groups, filterValueFields
	filterFields = _.without filterFields, null, undefined
	filter_scope = reportObject.filter_scope || "space"
	filters = reportObject.filters
	Meteor.call "report_data",{object_name: objectName, space: spaceId, filter_scope: filter_scope, filters: filters, fields: filterFields}, (error, result)->
		if error
			console.error('report_data method error:', error)
			return
		
		reportColumns = reportObject.columns?.map (item, index)->
			itemFieldKey = item.replace(/\./g,"_")
			itemField = objectFields[item.split(".")[0]]
			return {
				caption: itemField.label
				dataField: itemFieldKey
			}
		unless reportColumns
			reportColumns = []
		reportData = result
		_.each reportObject.groups, (group, index)->
			groupFieldKey = group.replace(/\./g,"_")
			groupField = objectFields[group.split(".")[0]]
			reportColumns.push 
				caption: groupField.label
				dataField: groupFieldKey
				groupIndex: index

		reportSummary = {}
		totalSummaryItems = []
		groupSummaryItems = []
		
		_.each reportObject.values, (value)->
			unless value.field
				return
			unless value.operation
				return
			valueFieldKey = value.field.replace(/\./g,"_")
			# valueField = objectFields[value.field.split(".")[0]]
			summaryItem = 
				column: valueFieldKey
				summaryType: value.operation
				displayFormat: value.label
			if ["max","min"].indexOf(value.operation) > -1
				summaryItem.alignByColumn = true
			else if ["sum"].indexOf(value.operation) > -1
				summaryItem.showInGroupFooter = true
			if value.grouping
				groupSummaryItems.push summaryItem
			else
				totalSummaryItems.push summaryItem
		
		unless _.isEmpty totalSummaryItems
			reportSummary.totalItems = totalSummaryItems
		unless _.isEmpty groupSummaryItems
			reportSummary.groupItems = groupSummaryItems

		pivotGrid = $('#pivotgrid').dxDataGrid(
			dataSource: reportData
			paging: false
			columns: reportColumns,
			summary: reportSummary).dxDataGrid('instance')
		return

renderMatrixReport = (reportObject, spaceId)->
	objectName = reportObject.object_name
	objectFields = Creator.getObject(objectName)?.fields
	if _.isEmpty objectFields
		return
	filterValueFields = reportObject.values?.map (item, index)->
		return item.field
	filterFields = _.union reportObject.columns, reportObject.rows, filterValueFields
	filterFields = _.without filterFields, null, undefined
	filter_scope = reportObject.filter_scope || "space"
	filters = reportObject.filters
	Meteor.call "report_data",{object_name: objectName, space: spaceId, filter_scope: filter_scope, filters: filters, fields: filterFields}, (error, result)->
		if error
			console.error('report_data method error:', error)
			return
		
		reportFields = []
		reportData = result
		_.each reportObject.rows, (row)->
			rowFieldKey = row.replace(/\./g,"_")
			rowField = objectFields[row.split(".")[0]]
			caption = rowField.label
			unless caption
				caption = objectName + "_" + rowFieldKey
			reportFields.push 
				caption: caption
				width: 100
				dataField: rowFieldKey
				area: 'row'
		_.each reportObject.columns, (column)->
			columnFieldKey = column.replace(/\./g,"_")
			columnField = objectFields[column.split(".")[0]]
			caption = columnField.label
			unless caption
				caption = objectName + "_" + columnFieldKey
			reportFields.push 
				caption: caption
				width: 100
				dataField: columnFieldKey
				area: 'column'
		_.each reportObject.values, (value)->
			unless value.field
				return
			unless value.operation
				return
			valueFieldKey = value.field.replace(/\./g,"_")
			valueField = objectFields[value.field.split(".")[0]]
			caption = value.label
			unless caption
				caption = valueField.label
			unless caption
				caption = objectName + "_" + valueFieldKey
			reportFields.push 
				caption: caption
				dataField: valueFieldKey
				# dataType: valueField.type
				summaryType: value.operation
				area: 'data'

		pivotGridChart = $('#pivotgrid-chart').dxChart(
			commonSeriesSettings: type: 'bar'
			tooltip:
				enabled: true
			size: height: 300
			adaptiveLayout: width: 450).dxChart('instance')
		pivotGrid = $('#pivotgrid').dxPivotGrid(
			paging: false
			allowSortingBySummary: true
			allowFiltering: true
			showBorders: true
			showColumnGrandTotals: true
			showRowGrandTotals: true
			showRowTotals: true
			showColumnTotals: true
			fieldChooser:
				enabled: true
				height: 600
			dataSource:
				fields: reportFields
				store: reportData).dxPivotGrid('instance')
		pivotGrid.bindChart pivotGridChart,
			dataFieldsDisplayMode: 'splitPanes'
			alternateDataFields: false
		return


Template.creator_report.onRendered ->
	DevExpress.localization.locale("zh")
	this.autorun (c)->
		spaceId = Session.get("spaceId")
		unless spaceId
			return
		record_id = Session.get "record_id"
		unless record_id
			return
		if Creator.subs["CreatorRecord"].ready()
			c.stop()
			reportObject = Creator.Reports[record_id] or Creator.getObjectRecord()
			unless reportObject
				return
			switch reportObject.report_type
				when 'tabular'
					renderTabularReport(reportObject, spaceId)
				when 'summary'
					renderSummaryReport(reportObject, spaceId)
				when 'matrix'
					renderMatrixReport(reportObject, spaceId)


Template.creator_report.onCreated ->
	Session.set("show_filter_option", true)

	this.filter_PTop = new ReactiveVar("-1000px")
	this.filter_PLeft = new ReactiveVar("-1000px")
	this.filter_index = new ReactiveVar()
	this.is_edit_scope = new ReactiveVar()

	this.autorun (c)->
		record_id = Session.get "record_id"
		unless record_id
			return
		if Creator.subs["CreatorRecord"].ready()
			c.stop()
			reportObject = Creator.Reports[record_id] or Creator.getObjectRecord()
			unless reportObject
				return
			objectName = reportObject.object_name
			filter_items = reportObject.filters || []
			filter_scope = reportObject.filter_scope
			Session.set("filter_items", filter_items)
			Session.set("filter_scope", filter_scope)