yaml = require('js-yaml')
clone = require("clone")
@ListView = {}

ListView.getNew = ()->
	gridState = Session.get("gridState");
	columns = gridState.columns;
	listView = clone(Creator.getListView(Session.get("object_name"),Session.get("list_view_id"),true))
	sort = []
	_.forEach listView.columns, (column, i)->
		field_name = ""
		if _.isString(column)
			field_name = column
			gdColumn = _.findWhere(columns , {dataField: column})
			_column = {field: column,  _index: gdColumn.visibleIndex}
			if gdColumn.width || _.isNumber(gdColumn.width)
				_column.width = gdColumn.width
			listView.columns[i] = _column
			if gdColumn.sortIndex
				sort.push({field_name: column, order: gdColumn.sortOrder})
		else
			field_name = column.field
			gdColumn = _.findWhere(columns , {dataField: column.field})
			if gdColumn.width || _.isNumber(gdColumn.width)
				column.width = gdColumn.width
			column._index = gdColumn.visibleIndex

		if _.has gdColumn, "sortIndex"
			sort.push({field_name: field_name, order: gdColumn.sortOrder, _index: gdColumn.sortIndex})

	listView.columns = _.sortBy(listView.columns, '_index');

	_.forEach listView.columns, (column)->
		delete 	column._index

	sort = _.sortBy(sort, '_index');
	_.forEach sort, (_s)->
		delete 	_s._index
	listView.sort = sort

	listView.filters = Session.get("filter_items")

	return listView

ListView.exportToYml = ()->
	listView = ListView.getNew()

	_listView = _.pick(listView, "label", "columns", "filters", "filter_fields", "sort")

	_listView1 = {}

	_listView['testArray'] = [ [ "value", ">", 3 ], "and", [ "value", "<", 7 ] ]

	_listView1[listView.name] = _listView



	yml = yaml.dump _listView1, {noArrayIndent: true, flowLevel: 1}

	element = createDownloadLink({data: yml, title: "#{listView.name}.yml", filename: "#{listView.name}.yml"})
#	document.body.appendChild(element);
	element.click();
#	document.body.removeChild(element);

createDownloadLink = (opt)->
	throwError = (name) ->
		throw new Error('No ' + name + ' provided to createDownloadLink.');

	data = opt.data || throwError('data');
	title = opt.title || throwError('title');
	filename = opt.filename || throwError('filename');

	anchor = document.createElement('a');

	attachDataAsOctetStream = (data)->
		link = 'data:application/octet-stream,' + encodeURIComponent(data);
		anchor.setAttribute('href', link);

	setFilename = (filename) ->
		anchor.setAttribute('download', filename);

	setTitle = (title) ->
		anchor.appendChild(document.createTextNode(title));

	attachDataAsOctetStream(data);
	setFilename(filename);
	setTitle(title);
	return anchor;

ListView.getFilterFields = (listView)->
	filterFields = []
	if listView?.filter_conditions
		_.each listView.filter_conditions, (filter)->
			filterFields.push(filter)
	if filterFields.length < 1
		return null
	return filterFields