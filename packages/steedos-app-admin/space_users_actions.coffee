actions = 
	import:
		label: "导入"
		on: "list"
		visible: true
		todo: ()->
			if !Steedos.isPaidSpace()
				Steedos.spaceUpgradedModal()
				return;

			Modal.show("import_users_modal");
	
	export:
		label: "导出"
		on: "list"
		visible: true
		todo: ()->
			alert("导出2")

unless Creator.Objects.space_users?.actions
	Creator.Objects.space_users.actions = {}

_.extend(Creator.Objects.space_users.actions, actions);
