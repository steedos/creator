Template.creator_grid_sidebar_organizations.onRendered ->
	self = this
	self.autorun (c)->
		list_view_id = "all"
		object_name = "organizations"
		user_permission_sets = Session.get("user_permission_sets")
		user_company_id = Session.get("user_company_id")
		isSpaceAdmin = Creator.isSpaceAdmin()
		isOrganizationAdmin = _.include(user_permission_sets,"organization_admin")
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
						onLoading: (loadOptions)->
							loadOptions.select = ["name", "parent", "children"]
						onLoaded: (results)->
							if results and _.isArray(results)
								_.each results, (item)->
									# 判断是否有下级节点
									item.hasItems = false
									if item.children?.length > 0
										item.hasItems = true
									# 根节点自动展开
									if !item.parent
										item.expanded = true
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
				Session.set "grid_sidebar_selected", selectedKeys
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
			dxOptions.hasItemsExpr = "hasItems"
			dxOptions.rootValue = null
			dxOptions.dataStructure = "plain"
			dxOptions.virtualModeEnabled = true 
			
			unless isSpaceAdmin
				if isOrganizationAdmin
					if user_company_id
						dxOptions.rootValue = user_company_id
					else
						dxOptions.rootValue = "-1"
				else
					dxOptions.rootValue = "-1"

			self.$(".gridSidebarContainer").dxTreeView(dxOptions).dxTreeView('instance')
			
Template.creator_grid_sidebar_organizations.helpers Creator.helpers

Template.creator_grid_sidebar_organizations.helpers 

Template.creator_grid_sidebar_organizations.events

Template.creator_grid_sidebar_organizations.onCreated ->

Template.creator_grid_sidebar_organizations.onDestroyed ->
	Session.set "grid_sidebar_selected", null
	Session.set "grid_sidebar_filters", null