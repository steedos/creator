_expandFields = (object_name, columns)->
	expand_fields = []
	fields = Creator.getObject(object_name).fields
	_.each columns, (n)->
		if fields[n]?.type == "master_detail" || fields[n]?.type == "lookup"
			if fields[n].reference_to
				ref = fields[n].reference_to
				if _.isFunction(ref)
					ref = ref()
			else
				ref = fields[n].optionsFunction({}).getProperty("value")

			if !_.isArray(ref)
				ref = [ref]
				
			ref = _.map ref, (o)->
				key = Creator.getObject(o)?.NAME_FIELD_KEY || "name"
				return key

			ref = _.compact(ref)

			ref = _.uniq(ref)
			
			ref = ref.join(",")

			if ref
				expand_fields.push(n + "($select=" + ref + ")")
			# expand_fields.push n + "($select=name)"
	return expand_fields

_columns = (object_name, columns, list_view_id)->
	object = Creator.getObject(object_name)
	defaultWidth = _defaultWidth(columns, object.enable_tree)
	column_default_sort = Creator.transformSortToDX(Creator.getObjectDefaultSort(object_name))
	list_view = Creator.getListView(object_name, list_view_id)
	list_view_sort = Creator.transformSortToDX(list_view?.sort)
	if !_.isEmpty(list_view_sort)
		list_view_sort = list_view_sort
	else
		#默认读取default view的sort配置
		list_view_sort = column_default_sort
	
	result = columns.map (n,i)->
		field = object.fields[n]
		columnItem = 
			cssClass: "slds-cell-edit"
			caption: field.label || TAPi18n.__(object.schema.label(n))
			dataField: n
			alignment: "left"
			cellTemplate: (container, options) ->
				htmlText = """
					<span class="creator_table_cell slds-grid slds-grid_align-spread field-text">
						<div class="slds-truncate cell-container">
							#{options.data[n]}
						</div>
					</span>
				"""
				$("<div>").append(htmlText).appendTo(container)
		
		unless field.sortable
			columnItem.allowSorting = false
		return columnItem
	
	console.log "========_columns===============list_view_sort====", list_view_sort
	if !_.isEmpty(list_view_sort)
		_.each list_view_sort, (sort,index)->
			sortColumn = _.findWhere(result,{dataField:sort[0]})
			if sortColumn
				sortColumn.sortOrder = sort[1]
				sortColumn.sortIndex = index
	console.log "========_columns===============result====", result
	
	return result

_defaultWidth = (columns, isTree)->
	column_counts = columns.length
	subWidth = if isTree then 46 else 46 + 60 + 60
	content_width = $(".gridContainer").width() - subWidth
	return content_width/column_counts

_depandOnFields = (object_name, columns)->
	fields = Creator.getObject(object_name).fields
	depandOnFields = []
	_.each columns, (column)->
		if fields[column]?.depend_on
			depandOnFields = _.union(fields[column].depend_on)
	return depandOnFields

Template.creator_grid_sidebar_organizations.onRendered ->
	self = this
	self.autorun (c)->
		list_view_id = "all"
		object_name = "organizations"
		if Steedos.spaceId()
			url = "/api/odata/v4/#{Steedos.spaceId()}/#{object_name}"
			filter = Creator.getODataFilter(list_view_id, object_name)
			if !filter
				filter = ["_id", "<>", -1]
			# 左侧grid视图，只显示name字段
			selectColumns = ["name"]
			extra_columns = ["owner","sort_no","parent","children"]
			defaultExtraColumns = Creator.getObjectDefaultExtraColumns(object_name)
			if defaultExtraColumns
				extra_columns = _.union extra_columns, defaultExtraColumns
			#expand_fields 不需要包含 extra_columns
			expand_fields = _expandFields(object_name, selectColumns)
			# 这里如果不加nonreactive，会因为后面customSave函数插入数据造成表Creator.Collections.settings数据变化进入死循环
			showColumns = Tracker.nonreactive ()-> return _columns(object_name, selectColumns, list_view_id)
			# extra_columns不需要显示在表格上，因此不做_columns函数处理
			selectColumns = _.union(selectColumns, extra_columns)
			selectColumns = _.union(selectColumns, _depandOnFields(object_name, selectColumns))
			_.every showColumns, (n)->
				n.sortingMethod = Creator.sortingMethod

			dxOptions = 
				showColumnLines: false
				allowColumnReordering: true
				allowColumnResizing: true
				columnResizingMode: "widget"
				showRowLines: true
				dataSource: 
					store: 
						type: "odata"
						version: 4
						url: Steedos.absoluteUrl(url)
						withCredentials: false
						beforeSend: (request) ->
							request.headers['X-User-Id'] = Meteor.userId()
							request.headers['X-Space-Id'] = Steedos.spaceId()
							request.headers['X-Auth-Token'] = Accounts._storedLoginToken()
						errorHandler: (error) ->
							if error.httpStatus == 404 || error.httpStatus == 400
								error.message = t "creator_odata_api_not_found"
							else if error.httpStatus == 401
								error.message = t "creator_odata_unexpected_character"
							else if error.httpStatus == 403
								error.message = t "creator_odata_user_privileges"
							else if error.httpStatus == 500
								if error.message == "Unexpected character at 106" or error.message == 'Unexpected character at 374'
									error.message = t "creator_odata_unexpected_character"
							toastr.error(error.message)
						fieldTypes: {
							'_id': 'String'
						}
					select: selectColumns
					filter: filter
					expand: expand_fields
				columns: showColumns
				columnAutoWidth: true
				sorting: 
					mode: "multiple"
			sidebar_multiple = false
			dxOptions.selection = 
				mode: if sidebar_multiple then "multiple" else "single"
			dxOptions.onSelectionChanged = (selectionInfo)->
				selectedData = selectionInfo.selectedRowsData
				if selectedData and selectedData.length
					sidebar_filter_key = "organizations"
					sidebar_values = _.pluck(selectedData,"_id")
					if sidebar_values.length == 1
						sidebarFilter = [ sidebar_filter_key, "=", sidebar_values[0] ]
					else if sidebar_values.length > 1
						sidebarFilter = []
						sidebar_values.forEach (value_item)->
							sidebarFilter.push [ sidebar_filter_key, "=", value_item ]
							sidebarFilter.push "or"
						sidebarFilter.pop()
					console.log "grid_sidebar_filters==========", sidebarFilter
					Session.set "grid_sidebar_filters", sidebarFilter

			# 如果是tree则过虑条件适用tree格式，要排除相关项is_related的情况，因为相关项列表不需要支持tree
			dxOptions.keyExpr = "_id"
			dxOptions.parentIdExpr = "parent"
			dxOptions.hasItemsExpr = (params)->
				if params?.children?.length>0
					return true 
				return false;
			dxOptions.expandNodesOnFiltering = true
			# tree 模式不能设置filter，filter由tree动态生成
			dxOptions.dataSource.filter = null
			dxOptions.rootValue = null
			dxOptions.remoteOperations = 
				filtering: true
				sorting: false
				grouping: false
			dxOptions.scrolling = null
			self.dxDataGridInstance = self.$(".gridContainer").dxTreeList(dxOptions).dxTreeList('instance')
			
Template.creator_grid_sidebar_organizations.helpers Creator.helpers

Template.creator_grid_sidebar_organizations.helpers 

Template.creator_grid_sidebar_organizations.events
	'click td': (event, template)->
		if $(event.currentTarget).find(".slds-checkbox input").length
			# 左侧勾选框不要focus样式功能
			return
		if $(event.currentTarget).parent().hasClass("dx-freespace-row")
			# 最底下的空白td不要focus样式功能
			return
		template.$("td").removeClass("slds-has-focus")
		$(event.currentTarget).addClass("slds-has-focus")

Template.creator_grid_sidebar_organizations.onCreated ->