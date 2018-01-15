Template.creator_report.helpers


renderTabularReport = (reportObject)->
	spaceId = Session.get("spaceId")
	unless spaceId
		return
	objectName = reportObject.object_name
	objectFields = Creator.getObject(objectName)?.fields
	if _.isEmpty objectFields
		return
	filterFields = reportObject.columns
	Meteor.call "report_data",{object_name: objectName, space: spaceId, fields: filterFields}, (error, result)->
		if error
			console.error('report_data method error:', error)
			return
		
		reportColumns = reportObject.columns.map (item, index)->
			return item.split(".")[0]

		reportData = result

		pivotGrid = $('#pivotgrid').dxDataGrid(
			dataSource: reportData
			columns: reportColumns).dxDataGrid('instance')
		return


renderSummaryReport = (reportObject)->
	spaceId = Session.get("spaceId")
	unless spaceId
		return
	objectName = reportObject.object_name
	objectFields = Creator.getObject(objectName)?.fields
	if _.isEmpty objectFields
		return
	filterFields = _.union reportObject.columns, reportObject.groups
	Meteor.call "report_data",{object_name: objectName, space:spaceId, fields: filterFields}, (error, result)->
		if error
			console.error('report_data method error:', error)
			return
		
		reportColumns = reportObject.columns.map (item, index)->
			return item.split(".")[0]
		reportData = result
		_.each reportObject.groups, (group, index)->
			groupFieldKey = group.split(".")[0]
			groupField = objectFields[groupFieldKey]
			reportColumns.push 
				dataField: groupFieldKey
				groupIndex: index

		pivotGrid = $('#pivotgrid').dxDataGrid(
			dataSource: reportData
			allowColumnReordering: true
			grouping: 
				autoExpandAll: true
			paging: false
			columns: reportColumns).dxDataGrid('instance')
		return


renderMatrixReport = (reportObject)->
	spaceId = Session.get("spaceId")
	unless spaceId
		return
	objectName = reportObject.object_name
	objectFields = Creator.getObject(objectName)?.fields
	if _.isEmpty objectFields
		return
	filterValueFields = reportObject.values.map (item, index)->
		return item.field
	filterFields = _.union reportObject.columns, reportObject.rows, filterValueFields
	Meteor.call "report_data",{object_name: objectName, space:spaceId, fields: filterFields}, (error, result)->
		if error
			console.error('report_data method error:', error)
			return
		
		reportFields = []
		reportData = result
		_.each reportObject.rows, (row)->
			rowFieldKey = row.split(".")[0]
			rowField = objectFields[rowFieldKey]
			caption = rowField.label
			unless caption
				caption = objectName + "_" + rowFieldKey
			reportFields.push 
				caption: caption
				width: 100
				dataField: rowFieldKey
				area: 'row'
		_.each reportObject.columns, (column)->
			columnFieldKey = column.split(".")[0]
			columnField = objectFields[columnFieldKey]
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
			valueFieldKey = value.field.split(".")[0]
			valueField = objectFields[valueFieldKey]
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
	$ ->
		report_id = Session.get "report_id"
		unless report_id
			return
		reportObject = Creator.Reports[report_id]
		unless reportObject
			return
		Meteor.autorun (c)->
			switch reportObject.report_type
				when 'tabular'
					renderTabularReport(reportObject)
				when 'summary'
					renderSummaryReport(reportObject)
				when 'matrix'
					renderMatrixReport(reportObject)