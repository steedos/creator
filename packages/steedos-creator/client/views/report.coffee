Template.creator_report.helpers

renderTabularReport = (reportObject)->


renderSummaryReport = (reportObject)->
	spaceId = Session.get("spaceId")
	unless spaceId
		return
	objectName = reportObject.object_name
	objectFields = Creator.getObject(objectName)?.fields
	if _.isEmpty objectFields
		return
	Meteor.call "report_data",{object_name: objectName, space:spaceId}, (error, result)->
		if error
			console.error('report_data method error:', error)
			return
		
		reportColumns = reportObject.columns
		reportData = result
		_.each reportObject.groups, (group, index)->
			groupField = objectFields[group]
			reportColumns.push 
				dataField: group
				groupIndex: index

		# pivotGridChart = $('#pivotgrid-chart').dxChart(
		# 	commonSeriesSettings: type: 'bar'
		# 	tooltip:
		# 		enabled: true
		# 	size: height: 300
		# 	adaptiveLayout: width: 450).dxChart('instance')
		pivotGrid = $('#pivotgrid').dxDataGrid(
			dataSource: reportData
			allowColumnReordering: true
			grouping: 
				autoExpandAll: true
			paging:
				pageSize: 20
			columns: reportColumns).dxDataGrid('instance')
		# pivotGrid.bindChart pivotGridChart,
		# 	dataFieldsDisplayMode: 'splitPanes'
		# 	alternateDataFields: false
		return



renderMatrixReport = (reportObject)->
	spaceId = Session.get("spaceId")
	unless spaceId
		return
	objectName = reportObject.object_name
	objectFields = Creator.getObject(objectName)?.fields
	if _.isEmpty objectFields
		return
	Meteor.call "report_data",{object_name: objectName, space:spaceId}, (error, result)->
		if error
			console.error('report_data method error:', error)
			return
		
		reportFields = []
		reportData = result
		_.each reportObject.rows, (row)->
			rowField = objectFields[row]
			caption = rowField.label
			unless caption
				caption = objectName + "_" + row
			reportFields.push 
				caption: caption
				width: 100
				dataField: row
				area: 'row'
		_.each reportObject.columns, (column)->
			columnField = objectFields[column]
			caption = columnField.label
			unless caption
				caption = objectName + "_" + column
			reportFields.push 
				caption: caption
				width: 100
				dataField: column
				area: 'column'
		_.each reportObject.values, (value)->
			unless value.field
				return
			unless value.operation
				return
			valueField = objectFields[value.field]
			caption = value.label
			unless caption
				caption = valueField.label
			unless caption
				caption = objectName + "_" + value.field
			reportFields.push 
				caption: caption
				dataField: value.field
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