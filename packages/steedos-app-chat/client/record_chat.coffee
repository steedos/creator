Template.steedos_record_chat.onCreated ->
	console.log('record_chat created', this.data);
#	data = chatMessages.getRecordMessages(Session.get("spaceId"), this.data.object_name, this.data.record_id, {top: this.data.top})
#	this.messageList = new ReactiveVar(data)


Template.steedos_record_chat.helpers
	messageList: ()->
		data = chatMessages.getRecordMessages(Session.get("spaceId"), this.object_name, this.record_id);
		return data;

	fromNow: (date)->
		return moment(date).fromNow()

	ownerName: (owner)->
		return Creator.getCollection("users").findOne(owner)?.name

	ownerAvatarUrl: (owner)->
		avatarUrl = Creator.getCollection("users").findOne(owner)?.avatarUrl
		if !avatarUrl
			avatarUrl = Creator.getRelativeUrl("/packages/steedos_lightning-design-system/client/images/themes/oneSalesforce/lightning_lite_profile_avatar_96.png")
		return avatarUrl

	permissions: ()->
		permissions = Creator.getRecordPermissions('chat_messages', this, Meteor.userId())
		permissions._record = this
		return permissions

	showAction: ()->
		permissions = this
		return permissions.allowDelete or permissions.allowEdit

	message: ()->
		if this.name
			return Spacebars.SafeString(marked(this.name))

Template.steedos_record_chat.events
#	'click .chat-message-actions': (e, t)->
#		permissions = Creator.getRecordPermissions('chat_messages', this, Meteor.userId())
#		console.log('click .chat-message-actions', permissions);

	'click .remove-action': (e, t)->
		Creator.executeAction('chat_messages', {todo: 'standard_delete'}, this._record._id)

	'click .update-action': (e, t)->
		Session.set("cmFullScreen", false)
		Session.set 'cmDoc', this._record
		Session.set("action_fields", 'name')
		Session.set("action_collection", "Creator.Collections.chat_messages")
		Session.set("action_collection_name", Creator.getObject("chat_messages")?.label)
		Session.set("action_save_and_insert", false)
		Session.set 'cmIsMultipleUpdate', true
		Session.set 'cmTargetIds', Creator.TabularSelectedIds?.chat_messages
		Meteor.defer ()->
			$(".btn.creator-cell-edit").click()

	'click a': (e, t)->
		e.preventDefault()
		if e.target?.href
			Steedos.openWindow(e.target.href)