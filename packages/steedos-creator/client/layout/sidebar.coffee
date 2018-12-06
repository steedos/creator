Template.creatorSidebar.helpers Creator.helpers

Template.creatorSidebar.helpers

Template.creatorSidebar.onRendered ->
	$('#sidebar-menu').dxTreeView
		items: Creator.Menus
		dataStructure: 'plain'
		parentIdExpr: 'parent'
		keyExpr: '_id'
		displayExpr: 'name'
		searchEnabled: true
		expandEvent: "click"
		onItemClick: (e) ->
			# - template_name 指向 Meteor Template, url=/app/admin/_template/{template_name}/
			# - object_name 指向对象, url=/app/admin/{object_name}/grid/all/
			object_name = e.itemData?.object_name
			template_name = e.itemData?.template_name
			if object_name or template_name
				$('#sidebar-menu .dx-selected').removeClass("dx-selected");
				e.itemElement.addClass("dx-selected");
			if object_name
				FlowRouter.go("/app/admin/#{object_name}/grid/all")
			else if template_name
				FlowRouter.go("/app/admin/_template/#{template_name}")
