Template.creatorNavigation.helpers Creator.helpers

Template.creatorNavigation.helpers
	
	app_id: ()->
		return Session.get("app_id")

	app_name: ()->
		app = Creator.getApp()
		return if app then t(app.name) else ""

	app_objects: ()->
		return Creator.getAppObjectNames()

	object_i: ()->
		return Creator.getObject(this)

	object_class_name: (obj)->
		if (obj == FlowRouter.getParam("object_name"))
			return "slds-is-active"

	object_url: ()->
		return Creator.getObjectFirstListViewUrl(String(this), null)

	spaces: ->
		return db.spaces.find();

	spaceName: ->
		if Session.get("spaceId")
			space = db.spaces.findOne(Session.get("spaceId"))
			if space
				return space.name
		return t("none_space_selected_title")

	spacesSwitcherVisible: ->
		return db.spaces.find().count()>1;

	displayName: ->
		if Meteor.user()
			return Meteor.user().displayName()
		else
			return " "

	avatar: () ->
		return Meteor.user()?.avatar

	avatarURL: (avatar,w,h,fs) ->
		return Steedos.absoluteUrl("avatar/#{Meteor.userId()}?w=#{w}&h=#{h}&fs=#{fs}&avatar=#{avatar}");

	isNode: ()->
		return Steedos.isNode()
	
	hideObjects: ()->
		app = Creator.getApp()
		if app and app._id == "admin"
			return true
		else
			return false

	otherPages: ()->
		return Template.instance().otherPages.get()

	page_url: ()->
		if this.object_name
			return Creator.getObjectFirstListViewUrl(this.object_name, null)
		else if this.template_name
			return Creator.getRelativeUrl("/app/#{Session.get('app_id')}/page/#{this.template_name}")

	page_class_name: ()->
		if this.object_name
			if (this.object_name == FlowRouter.getParam("object_name"))
				return "slds-is-active"
		else if this.template_name
			if (this.template_name == FlowRouter.getParam("template_name"))
				return "slds-is-active"

	page_i: ()->
		if this.object_name
			return Creator.getObject(this.object_name)
		else if this.template_name
			return this.label || this.name

	app_tabs: ()->
		return Creator.getAppTabs()



Template.creatorNavigation.events

	"click .switchSpace": ->
		Steedos.setSpaceId(this._id)
		# 获取路由路径中第一个单词，即根目录
		rootName = FlowRouter.current().path.split("/")[1]
		FlowRouter.go("/#{rootName}")

	'click .app-list-btn': (event)->
		Modal.show("creator_app_list_modal")
	
	'click .header-refresh': (event)->
		window.location.reload(true)

	'click .nav-close': (event, t)->
		console.log('click .nav-close')
		otherPages = t.otherPages.get()
		closePage = this

		_.forEach otherPages, (page, index)->
			if closePage.object_name
				if page.object_name == closePage.object_name
					otherPages[index] = undefined
			else if closePage.template_name
				if page.template_name == closePage.template_name
					otherPages[index] = undefined

		otherPages = _.compact otherPages

		t.otherPages.set(otherPages)
		firstObj_a = $("a",$(event.currentTarget.parentNode.parentNode.parentNode).children("li:first-child"))
		if firstObj_a.length > 0
			firstObj_a[0].click()

Template.creatorNavigation.onCreated ()->
	self = this
	self.otherPages = new ReactiveVar([])
	getOtherPages = ()->
		return self.otherPages.get()

	self.autorun ()->
		session_object_name = Session.get("object_name")
		app_objects = Creator.getAppObjectNames() || []
		if session_object_name && !app_objects.includes(session_object_name)
			otherPages = (Tracker.nonreactive getOtherPages) || []
			exists = _.find otherPages, (page)->
				return page.object_name == session_object_name
			if !exists
				otherPages.push {object_name: session_object_name}
				self.otherPages.set otherPages

#	self.autorun ()->
#		session_template_name = Session.get("template_name")
#		app_objects = Creator.getAppObjectNames() || [] #TODO
#		if session_template_name &&  !app_objects.includes(session_template_name)
#			otherPages = (Tracker.nonreactive getOtherPages) || []
#			exists = _.find otherPages, (page)->
#				return page.template_name == session_template_name
#			if !exists
#				otherPages.push {template_name: session_template_name}
#				self.otherPages.set otherPages

	self.autorun ()->
		app_id = Session.get("app_id")
		self.otherPages.set([])