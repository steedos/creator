Template.filter_option_list.helpers 
	filterItems: ()->
		return Session.get("filter_items")

	filterScope: ()->
		scope = Session.get("filter_scope")
		if scope == "space"
			return "All"
		else if scope == "mine"
			return "My"
	
	relatedObject: ()->
		debugger
		object_name = Template.instance().data?.object_name
		unless object_name
			object_name = Session.get("object_name")
		return Creator.getObject(object_name)

Template.filter_option_list.events 
	'click .btn-filter-scope': (event, template)->
		# template.is_edit_scope.set(true)

		left = $(event.currentTarget).closest(".filter-list-container").offset().left
		# top = $(event.currentTarget).closest(".slds-item").offset().top
		top = $(event.currentTarget).closest("li").offset().top

		# offsetLeft = $(event.currentTarget).closest(".slds-template__container").offset().left
		# offsetTop = $(event.currentTarget).closest(".slds-template__container").offset().top
		# contentHeight = $(event.currentTarget).closest(".slds-item").height()
		offsetLeft = $(event.currentTarget).closest(".filter-list-wraper").offset().left
		offsetTop = $(event.currentTarget).closest(".filter-list-wraper").offset().top
		contentHeight = $(event.currentTarget).closest("li").height()

		# 弹出框的高度和宽度写死
		left = left - offsetLeft - 400 - 6
		top = top - offsetTop - 170/2 + contentHeight/2

		# Session.set("show_filter_option", false)
		if template.optionbox
			Blaze.remove template.optionbox
		Meteor.defer ->
			# Session.set("show_filter_option", true)
			# template.filter_PLeft.set("#{left}px")
			# template.filter_PTop.set("#{top}px")

			# filter_items = Session.get("filter_items")
			# if index > -1 and filter_items
			# 	filterItem = filter_items[index]
			console.log "click .filter-filter-item,left:", "#{left}px"
			object_name = template.data?.object_name
			unless object_name
				object_name = Session.get("object_name")
			data = 
				top: "#{top}px"
				left: "#{left}px"
				# index: index
				# filter_item: filterItem
				is_edit_scope: true
				object_name: object_name
			template.optionbox = Blaze.renderWithData(Template.filter_option, data, $(".filter-option-box")[0])

	'click .filter-option-item': (event, template)->
		debugger
		# template.is_edit_scope.set(false)
		index = $(event.currentTarget).closest(".filter-item").index()
		if index < 0
			index = 0

		left = $(event.currentTarget).closest(".filter-list-container").offset().left
		top = $(event.currentTarget).closest("li").offset().top
		contentHeight = $(event.currentTarget).closest("li").height()

		offsetLeft = $(event.currentTarget).closest(".filter-list-wraper").offset().left
		offsetTop = $(event.currentTarget).closest(".filter-list-wraper").offset().top

		# 弹出框的高度和宽度写死
		left = left - offsetLeft - 400 - 6
		top = top - offsetTop - 336/2 + contentHeight/2

		# 计算弹出框是否超出屏幕底部，导致出现滚动条，如果超出，调整top位置
		# 计算方式：屏幕高度 - 弹出框的绝对定位 - 弹出框的高度 - 弹出框父容器position:relative的offsetTop - 弹出框距离屏幕底部10px
		# 如果计算得出值小于0，则调整top，相应上调超出的高度
		windowHeight = $(window).height()
		windowOffset = $(window).height() - top - 336 - offsetTop - 10

		if windowOffset < 0
			top = top + windowOffset

		# Session.set("show_filter_option", false)

		if template.optionbox
			Blaze.remove template.optionbox
		Meteor.defer ->
			# Session.set("show_filter_option", true)
			# template.filter_index.set(index)
			# template.filter_PLeft.set("#{left}px")
			# template.filter_PTop.set("#{top}px")
			filter_items = Session.get("filter_items")
			if index > -1 and filter_items
				filterItem = filter_items[index]
			console.log "click .filter-option-item,left:", "#{left}px"
			object_name = template.data?.object_name
			unless object_name
				object_name = Session.get("object_name")
			data = 
				top: "#{top}px"
				left: "#{left}px"
				index: index
				filter_item: filterItem
				is_edit_scope: false
				object_name: object_name
			template.optionbox = Blaze.renderWithData(Template.filter_option, data, $(".filter-option-box")[0])

	'click .removeFilter': (event, template)->
		index = $(event.currentTarget).closest(".filter-item").index()
		if index < 0
			index = 0
		filter_items = Session.get("filter_items")
		filter_items.splice(index, 1)
		Session.set("filter_items", filter_items)

	'click .add-filter': (event, template)->
		filter_items = Session.get("filter_items")
		filter_items.push({})
		Session.set("filter_items", filter_items)
		Meteor.defer ->
			template.$(".filter-option-item:last").click()

	'click .remove-all-filters': (event, template)->
		Session.set("filter_items", [])


Template.filter_option_list.onCreated ->
	self = this
	console.log "Template.filter_option_list.onCreatedxxxxxxxxxxxx"
	# Session.set("show_filter_option", true)

	# this.filter_PTop = new ReactiveVar("-1000px")
	# this.filter_PLeft = new ReactiveVar("-1000px")
	# this.filter_index = new ReactiveVar()
	# this.is_edit_scope = new ReactiveVar()
	# this.filter_dirty_count = new ReactiveVar(0)
	# this.filter_items_for_cancel = new ReactiveVar()
	# this.filter_scope_for_cancel = new ReactiveVar()
	# this.is_filter_open = new ReactiveVar(false)
	
	self.destroyOptionbox = ()->
		console.log "$(document).on wrapper===============click2"
		if self.optionbox and !self.optionbox.isDestroyed and $(self.optionbox.firstNode()).find(event.target).length == 0
			Blaze.remove self.optionbox
	
	$("body").on "click", self.destroyOptionbox

	# if self.optionbox and !self.optionbox.isDestroyed and $(self.optionbox.firstNode()).find(event.target).length == 0
	# 	Blaze.remove self.optionbox


Template.filter_option_list.onRendered ->
	# record_id = Session.get "record_id"
	# reportObject = Creator.Reports[record_id] or Creator.getObjectRecord()
	# self = this
	# this.autorun ()->
	# 	console.log "Template.filter_option_list.onRendered========"
	# 	filter_items = Session.get("filter_items")
	# 	index = self.filter_index.get()
	# 	isEditScope = self.is_edit_scope.get()
	# 	top = self.filter_PTop.get()
	# 	left = self.filter_PLeft.get()
	# 	filter_items = filter_items
	# 	if index > -1 and filter_items
	# 		filterItem = filter_items[index]
	# 	if self.optionbox
	# 		Blaze.remove self.optionbox
	# 	data = 
	# 		top:top
	# 		left:left
	# 		index:index
	# 		filter_item:filterItem
	# 		is_edit_scope:isEditScope
	# 		object_name:reportObject.object_name
	# 	self.optionbox = Blaze.renderWithData(Template.filter_option, data, $(".filter-option-box")[0]);

Template.filter_option_list.onDestroyed ->
	console.log "Template.filter_option_list.onDestroyed"
	$("body").off "click", self.destroyOptionbox
	