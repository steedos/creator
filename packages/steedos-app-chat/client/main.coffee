_actionItems = (object_name, record_id, record_permissions)->
	obj = Creator.getObject(object_name)
	actions = Creator.getActions(object_name)
	actions = _.filter actions, (action)->
		if action.on == "record" or action.on == "record_more"
			if action.only_detail
				return false
			if typeof action.visible == "function"
				return action.visible(object_name, record_id, record_permissions)
			else
				return action.visible
		else
			return false
	return actions

_itemClick = (record, curObjectName, list_view_id, target)->
	self = this
	if !record
		return

	if _.isObject(record._id)
		record._id = record._id._value

	record_permissions = Creator.getRecordPermissions curObjectName, record, Meteor.userId()
	actions = _actionItems(curObjectName, record._id, record_permissions)

	if actions.length
		actionSheetItems = _.map actions, (action)->
			return {text: action.label, record: record, action: action, object_name: curObjectName}
	else
		actionSheetItems = [{text: t("creator_list_no_actions_tip")}]

	actionSheetOption =
		dataSource: actionSheetItems
		showTitle: false
		usePopover: true
		onItemClick: (value)->
			console.log('onItemClick', value);
			action = value.itemData.action
			recordId = value.itemData.record._id
			objectName = value.itemData.object_name
			if action.todo == "standard_delete"
				Creator.executeAction 'chat_messages', {todo: 'standard_delete'}, recordId, '', '', '', ()->
					self.dxListInstance.reload()
			else if action.todo == "standard_edit"
				Session.set("cmFullScreen", false)
				Session.set 'cmDoc', {_id: recordId, name: value.itemData.record.name}
				Session.set("action_fields", 'name')
				Session.set("action_collection", "Creator.Collections.chat_messages")
				Session.set("action_collection_name", Creator.getObject("chat_messages")?.label)
				Session.set("action_save_and_insert", false)
				Session.set 'cmIsMultipleUpdate', true
				Session.set 'cmTargetIds', Creator.TabularSelectedIds?.chat_messages
				Meteor.defer ()->
					$(".btn.creator-cell-edit").click()
			else
				Creator.executeAction objectName, action, recordId, value.itemElement
	unless actions.length
		actionSheetOption.itemTemplate = (itemData, itemIndex, itemElement)->
			itemElement.html "<span class='text-muted'>#{itemData.text}</span>"

	actionSheet = $(".chat-action-sheet").dxActionSheet(actionSheetOption).dxActionSheet("instance")

	actionSheet.option("target", target);
	actionSheet.option("visible", true);

Template.steedos_chat_main.onCreated ->
	self = this
	AutoForm.hooks creatorCellEditForm:
		onSuccess: (formType,result)->
			self.dxListInstance?.reload()
	,false

Template.steedos_chat_main.events
	'click .remove-action': (e, t)->
		Creator.executeAction('chat_messages', {todo: 'standard_delete'}, e.currentTarget.dataset.id)

	'click .update-action': (e, t)->
		dataset = e.currentTarget.dataset
		Session.set("cmFullScreen", false)
		Session.set 'cmDoc', {_id: dataset.id, name: dataset.name}
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
		if e.currentTarget?.href && !e.currentTarget.href.startsWith("javascript")
			Steedos.openWindow(e.currentTarget.href,'_blank','width=800, height=600, left=50, top= 50, toolbar=no, status=no, menubar=no, resizable=yes, scrollbars=yes')

	'click .chat-actions': (e, t)->
		console.log('chat-actions...');

		data = Session.get('chat-main-item_data');

		_itemClick.call(t, data, 'chat_messages','chat', e.currentTarget)

	'click .chat-refresh .btn-refresh': (e, t)->
		t.dxListInstance.reload()

Template.steedos_chat_main.onRendered ()->
	itemTemplate = (data)->

		ownerAvatarUrl = data.owner.avatarUrl

		if !ownerAvatarUrl
			ownerAvatarUrl = Creator.getRelativeUrl("/packages/steedos_lightning-design-system/client/images/themes/oneSalesforce/lightning_lite_profile_avatar_96.png")
		else
			ownerAvatarUrl = Steedos.absoluteUrl ownerAvatarUrl

		ownerName = data.owner.name

		message = ""

		if data.name
			message = Spacebars.SafeString(marked(data.name))

		permissions = Creator.getRecordPermissions('chat_messages', data, Meteor.userId())

		showAction = permissions.allowDelete or permissions.allowEdit

		actionTemplate = ""

		if showAction
			actionTemplate = """
				<div class="slds-dropdown-trigger slds-dropdown-trigger_click slds-button_las chat-actions" data-id="#{data._id}">
					<button class="slds-button slds-button_icon-border slds-button_icon-x-small chat-message-actions" data-toggle="dropdown" aria-haspopup="true">
						#{Blaze.toHTMLWithData Template.steedos_button_icon, {class: "slds-button__icon slds-icon-utility-down", source: "utility-sprite", name:"down"}}
						<span class="slds-assistive-text">More Options</span>
					</button>
				</div>
			"""

		created = moment(data.created).fromNow()

		template = """
			<li class="slds-feed__item slds-border_bottom">
				<article class="slds-post">
					<header class="slds-post__header slds-media">
						<div class="slds-media__figure">
							<a href="javascript:void(0);" class="slds-avatar slds-avatar_circle slds-avatar_large" style="width: 2rem;height: 2rem;">
								<img src="#{ownerAvatarUrl}"/>
							</a>
						</div>
						<div class="slds-media__body">
							<div class="slds-grid slds-grid_align-spread slds-has-flexi-truncate">
								<p>
									<span class="cuf-entityLinkId forceChatterEntityLink entityLinkHover" data-id="0010o00002BawdQAAR" data-hashtag="" isslashrecord="false">
										<a class="cuf-entityLink cuf-entityLink" href="#{Creator.getObjectUrl(data.related_to?['reference_to._o'], data.related_to?._id)}" data-sfdc-wired-mouseover="" data-sfdc-wired-mouseout="" data-sfdc-wired-focus="" data-sfdc-wired-blur="">
											<span dir="ltr" class="uiOutputText">#{data.related_to?._NAME_FIELD_VALUE}</span>
										</a>
									</span>
									<span dir="ltr" class="uiOutputText"> — </span>
									<span class="cuf-entityLinkId forceChatterEntityLink entityLinkHover" data-id="0050o00000VU3QoAAL" data-hashtag="" isslashrecord="false">
										<a class="cuf-entityLink cuf-entityLink" title="#{ownerName}" href="#{Creator.getObjectUrl(data.owner?['reference_to._o'], data.owner?._id)}" data-sfdc-wired-mouseover="" data-sfdc-wired-mouseout="" data-sfdc-wired-focus="" data-sfdc-wired-blur="">
											<span dir="ltr" class="uiOutputText">#{ownerName}</span>
										</a>
									</span>
								</p>
								#{actionTemplate}
							</div>
							<p class="slds-text-body_small">#{created}</p>
						</div>
					</header>
					<div class="slds-post__content slds-text-longform" style="margin-bottom: 0px">
						<p>#{message}</p>
					</div>
				</article>
			</li>
		"""

	odata_dataSource = {
		store:
			type: "odata"
			version: 4
			url: Steedos.absoluteUrl("/api/odata/v4/#{Steedos.spaceId()}/chat_messages")
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
		select: 'name,type,created,owner,related_to'
		expand: 'owner($select=name,avatarUrl),related_to($select=name)'
	}
	console.log('odata_dataSource', odata_dataSource)
	listWidget = $("#chat_messages_list").dxList({
		dataSource: odata_dataSource
		searchEnabled: true
		searchExpr: "name"
		activeStateEnabled: false
		focusStateEnabled: false
		hoverStateEnabled: false
		indicateLoading: true
		bounceEnabled:false
#		showSelectionControls: true,
#		selectionMode: "multiple",
		itemTemplate: (data)->
			return itemTemplate(data)
		onItemClick: (e, a, b)->
			Session.set('chat-main-item_data', e.itemData)
	}).dxList("instance")

	this.dxListInstance = listWidget

Template.steedos_chat_main.onDestroyed ->
	self.dxListInstance = null