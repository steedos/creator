Template.creator_grid_sidebar_organizations.onRendered ->
	self = this
	self.autorun (c)->
		list_view_id = "all"
		object_name = "organizations"
		if Steedos.spaceId()
			url = "/api/odata/v4/#{Steedos.spaceId()}/#{object_name}"
			dxOptions = 
				searchEnabled: false
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
					sort: [ {
						selector: 'sort_no'
						desc: true
					},{
						selector: 'name'
						desc: false
					} ]
			
			sidebar_multiple = false
			dxOptions.selectNodesRecursive = false
			dxOptions.selectByClick = true
			dxOptions.selectionMode = if sidebar_multiple then "multiple" else "single"
			dxOptions.showCheckBoxesMode = if sidebar_multiple then "normal" else "none"
			dxOptions.onItemSelectionChanged = (selectionInfo)->
				selectedKeys = selectionInfo.component.getSelectedNodesKeys()
				if selectedKeys and selectedKeys.length
					sidebar_filter_key = "organizations"
					if selectedKeys.length == 1
						sidebarFilter = [ sidebar_filter_key, "=", selectedKeys[0] ]
					else if selectedKeys.length > 1
						sidebarFilter = []
						selectedKeys.forEach (value_item)->
							sidebarFilter.push [ sidebar_filter_key, "=", value_item ]
							sidebarFilter.push "or"
						sidebarFilter.pop()
					Session.set "grid_sidebar_filters", sidebarFilter

			dxOptions.keyExpr = "_id"
			dxOptions.parentIdExpr = "parent"
			dxOptions.displayExpr = "name"
			# hasItemsExpr功能有bug，function模式时能进入hasItemsExpr函数，但是参数params始终为undefined
			# dxOptions.hasItemsExpr = "children"
			dxOptions.hasItemsExpr = (params)=>
				if params?.children?.length>0
					return true 
				return false;
			dxOptions.rootValue = null
			dxOptions.dataStructure = "plain"
			dxOptions.virtualModeEnabled = true 
			self.dxDataGridInstance = self.$(".gridContainer").dxTreeView(dxOptions).dxTreeView('instance')
			
Template.creator_grid_sidebar_organizations.helpers Creator.helpers

Template.creator_grid_sidebar_organizations.helpers 

Template.creator_grid_sidebar_organizations.events

Template.creator_grid_sidebar_organizations.onCreated ->