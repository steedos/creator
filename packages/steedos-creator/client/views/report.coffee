Template.creator_report.helpers



Template.creator_report.onRendered ->
	DevExpress.localization.locale("zh")
	$ ->
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
				fields: [
					{
						caption: 'Region'
						width: 120
						dataField: 'region'
						area: 'row'
						sortBySummaryField: 'Total'
					}
					{
						caption: 'City'
						dataField: 'city'
						width: 150
						area: 'row'
					}
					{
						dataField: 'date'
						dataType: 'date'
						area: 'column'
					}
					{
						groupName: 'date'
						groupInterval: 'month'
						visible: false
					}
					{
						caption: 'Total'
						dataField: 'amount'
						dataType: 'number'
						summaryType: 'sum'
						format: 'currency'
						area: 'data'
					}
				]
				store: report_data).dxPivotGrid('instance')
		pivotGrid.bindChart pivotGridChart,
			dataFieldsDisplayMode: 'splitPanes'
			alternateDataFields: false
		return



@report_data = [
	{
		'id': 10248
		'region': 'North America'
		'country': 'United States of America'
		'city': 'New York'
		'amount': 1740
		'date': new Date('2013-01-06')
	}
	{
		'id': 10249
		'region': 'North America'
		'country': 'United States of America'
		'city': 'Los Angeles'
		'amount': 850
		'date': new Date('2014-01-13')
	}
	{
		'id': 10250
		'region': 'North America'
		'country': 'United States of America'
		'city': 'Denver'
		'amount': 2235
		'date': new Date('2013-01-07')
	}
	{
		'id': 10251
		'region': 'North America'
		'country': 'Canada'
		'city': 'Vancouver'
		'amount': 1965
		'date': new Date('2014-01-03')
	}
	{
		'id': 10252
		'region': 'North America'
		'country': 'Canada'
		'city': 'Edmonton'
		'amount': 880
		'date': new Date('2013-01-10')
	}
	{
		'id': 10253
		'region': 'South America'
		'country': 'Brazil'
		'city': 'Rio de Janeiro'
		'amount': 5260
		'date': new Date('2015-01-17')
	}
	{
		'id': 10254
		'region': 'South America'
		'country': 'Argentina'
		'city': 'Buenos Aires'
		'amount': 2790
		'date': new Date('2013-01-21')
	}
	{
		'id': 10255
		'region': 'South America'
		'country': 'Paraguay'
		'city': 'Asuncion'
		'amount': 3140
		'date': new Date('2015-01-01')
	}
]