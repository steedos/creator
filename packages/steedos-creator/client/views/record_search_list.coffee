Template.record_search_list.onCreated ()->
	this.sidebarList = new ReactiveVar([])
	this.searchResult = new ReactiveVar()

Template.record_search_list.onRendered ->
	self = this
	this.autorun ->
		searchText = Session.get("search_text")
		Meteor.call 'object_record_search', {searchText: searchText, space: Session.get("spaceId")}, (error, result)->
			if error
				console.error('object_record_search method error:', error);

			if result and result.length > 0
				searchResult = _.groupBy(result, "_object_name")
				sidebarList = _.keys(searchResult)
				self.searchResult.set(searchResult)			
				self.sidebarList.set(sidebarList)
			# console.log "record_search_list",JSON.stringify(result)


Template.record_search_list.helpers 
	sidebar_list: ()->
		return Template.instance().sidebarList.get()

	calc_result_ids: (object_name)->
		search_result = Template.instance().searchResult.get()
		obj = _.pick(search_result, object_name)
		ids = obj[object_name].getProperty("_id")
		return ids

	searchResult: ()->
		return Template.instance().searchResult.get()
		 

Template.record_search_list.events 
	"click #foo": (event, template) -> 
		 
