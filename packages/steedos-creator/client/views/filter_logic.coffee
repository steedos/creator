Template.filter_logic.onCreated ->
	self = this
	self.showFilterLogic = new ReactiveVar()
	self.autorun -> 
		list_view_obj = Creator.Collections.object_listviews.findOne(Session.get("list_view_id"))
		if list_view_obj
			if list_view_obj.filter_logic
				self.showFilterLogic.set(true)
			else
				self.showFilterLogic.set(false)
		else
			self.showFilterLogic.set(false)


Template.filter_logic.helpers 
	default_filter_logic: ()->
		list_view_obj = Creator.Collections.object_listviews.findOne(Session.get("list_view_id"))
		if list_view_obj
			return list_view_obj.filter_logic || ""

	show_filter_logic: ()->
		return Template.instance().showFilterLogic?.get()
		 

Template.filter_logic.events 
	'click .add_filter_logic': (e, t)->
		t.showFilterLogic.set(true)
		 
