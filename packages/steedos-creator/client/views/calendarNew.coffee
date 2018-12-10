dxSchedulerInstance = null

_getSelect = (options)->
	select = ['_id', 'owner', 'name']

	if options.startDateExpr
		select.push(options.startDateExpr)

	if options.endDateExpr
		select.push(options.endDateExpr)

	if options.textExpr
		select.push(options.textExpr)

	if options.title && _.isArray(options.title)
		select = select.concat(options.title)

	return _.uniq(select)

_dataSource = (options) ->
	filter = Creator.getODataFilter(Session.get("list_view_id"), Session.get('object_name'))
	url = "/api/odata/v4/#{Steedos.spaceId()}/#{Session.get('object_name')}"
	dataSource = {
		store:
			type: "odata"
			version: 4
			url: Steedos.absoluteUrl(url)
			deserializeDates: false
			withCredentials: false
			onLoaded: (a,b,c)->
			onLoading: (loadOptions)->
				startDate = loadOptions.dxScheduler.startDate
				endDate = loadOptions.dxScheduler.endDate
				_f = [
					[[ options.startDateExpr, ">=", startDate], 'and', [ options.startDateExpr, "<=", endDate]],
					"or",
					[[ options.endDateExpr, ">=", startDate], 'and', [ options.endDateExpr, "<=", endDate]]
				]

				if loadOptions.filter && _.isArray(loadOptions.filter)
					loadOptions.filter = [loadOptions.filter, 'and', _f]
				else
					loadOptions.filter = _f
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
		select: _getSelect(options)
		expand: ["owner($select=name)"]
		filter: filter
	}
	return dataSource

_getAppointmentTemplate = (options)->
	appointmentTemplate = (data)->
		title = data[options.textExpr || 'name'];
		if options.title && _.isArray(options.title) && options.title.length > 0
			title = ''
			fields = Creator.getObject().fields;
			_.each options.title, (t)->
				f = fields[t]
				title += "#{f.label || t}: #{data[t]}&#10;"
		return $("""
				<div style='height: 100%;' title='#{title}'>
					<div class='dx-scheduler-appointment-title'>#{data[options.textExpr || 'name']}</div>
					<div class='dx-scheduler-appointment-content-details' style='white-space: nowrap;'>
						<div class='dx-scheduler-appointment-content-date'>#{DevExpress.localization.formatDate(new Date(data[options.startDateExpr]), 'hh:mm a')}</div>
						<div class='dx-scheduler-appointment-content-date'> - </div>
						<div class='dx-scheduler-appointment-content-date'>#{DevExpress.localization.formatDate(new Date(data[options.endDateExpr]), 'hh:mm a')}</div>
					</div>
				</div>
			""");

	return appointmentTemplate;

_getTooltipTemplate = (data, options) ->

	permission = Creator.getRecordPermissions(Session.get('object_name'), data, Meteor.userId())

	actions = Creator.getActions()

	editAction = _.find actions, (action)->
			return action.name == 'standard_edit'

	if _.isFunction(editAction.visible)
		editAction._visible = editAction.visible(Session.get('object_name'), data._id, permission)
	else
		editAction._visible = editAction.visible

	deleteAction = _.find actions, (action)->
		return action.name == 'standard_delete'

	if _.isFunction(deleteAction.visible)
		deleteAction._visible = deleteAction.visible(Session.get('object_name'), data._id, permission)
	else
		deleteAction._visible = deleteAction.visible

	deleteBtn = ""

	if permission.allowDelete && deleteAction._visible
		deleteBtn = """
			<div class="dx-button dx-button-normal dx-widget dx-button-has-icon delete" role="button" aria-label="trash" tabindex="0">
				<div class="dx-button-content">
					<i class="dx-icon dx-icon-trash"></i>
				</div>
			</div>
		"""

	editBtn = """
		<div class="dx-button dx-button-normal dx-widget dx-button-has-text read dx-button-default" role="button" aria-label="查看" tabindex="0">
			<div class="dx-button-content">
				<span class="dx-button-text">查看</span>
			</div>
		</div>
	"""

	if permission.allowEdit && editAction._visible
		editBtn = """
			<div class="dx-button dx-button-normal dx-widget dx-button-has-text edit dx-button-default" role="button" aria-label="编辑" tabindex="0">
				<div class="dx-button-content">
					<span class="dx-button-text">编辑</span>
				</div>
			</div>
		"""

#	if !permission.allowEdit
#		return false
#
	action = """
		<div class="action">
			<div class="dx-scheduler-appointment-tooltip-buttons">
				#{deleteBtn}
				#{editBtn}
			</div>
		</div>
	"""
	str = """
		<div class='meeting-tooltip'>
			<div class="dx-scheduler-appointment-tooltip-title">#{data[options.textExpr || 'name']}</div>
			<div class='dx-scheduler-appointment-tooltip-date'>
				#{moment(data[options.startDateExpr]).tz("Asia/Shanghai").format("MMM D, h:mm A")} - #{moment(data[options.endDateExpr]).tz("Asia/Shanghai").format("MMM D, h:mm A")}
			</div>
			#{action}
		</div>
	"""
	return $(str)

_readData = (data) ->
	object_name = Session.get('object_name');
	action_collection_name = Creator.getObject(object_name).label
	Session.set("action_collection", "Creator.Collections.#{object_name}")
	Session.set("action_collection_name", action_collection_name)
	Session.set("action_save_and_insert", false)
	Session.set("cmDoc", data)
	Meteor.defer ->
		dxSchedulerInstance.hideAppointmentTooltip()
		window.open(Creator.getObjectUrl(object_name, data._id) ,'_blank','width=800, height=800, left=300, top=20,toolbar=no, status=no, menubar=no, resizable=yes, scrollbars=yes')


_executeAction = (action_name, data)->
	actions = Creator.getActions()
	action = _.find actions, (item)->
		return item.name == action_name
	if action
		objectName = Session.get("object_name")
		object = Creator.getObject(objectName)
		collection_name = object.label
		Session.set("action_fields", undefined)
		Session.set("action_collection", "Creator.Collections.#{objectName}")
		Session.set("action_collection_name", collection_name)
		Session.set("action_save_and_insert", false)
		dxSchedulerInstance.hideAppointmentTooltip()

		if action_name == 'standard_delete'
			Creator.executeAction objectName, action, data._id, null, null, ()->
				dxSchedulerInstance.repaint()
		else
			Creator.executeAction objectName, action, data._id

_editData = (data)->
	_executeAction 'standard_edit' , data

_deleteData = (data)->
	_executeAction 'standard_delete' , data

Template.creator_calendarNew.onCreated ->
	AutoForm.hooks creatorAddForm:
		onSuccess: (formType,result)->
			dxSchedulerInstance.repaint()
	,false
	AutoForm.hooks creatorEditForm:
		onSuccess: (formType,result)->
			dxSchedulerInstance.repaint()
	,false

Template.creator_calendarNew.onRendered ->
	self = this
	view = Creator.getListView(Session.get("object_name"), 'calendarView')
	self.autorun (c)->
		object_name = Session.get("object_name")
		if Steedos.spaceId()

			dxSchedulerConfig = {
				dataSource: _dataSource(view.options)
				views: [{
					type: "day",
					maxAppointmentsPerCell:"unlimited"
				}, {
					type:"week",
					maxAppointmentsPerCell:"unlimited"
				}, "month"]
				currentView: "month"
				currentDate: new Date()
				firstDayOfWeek: 1
				startDayHour: 8
				endDayHour: 18
				textExpr: 'name'
				endDateExpr: view.options.endDateExpr
				startDateExpr: view.options.startDateExpr
				timeZone: "Asia/Shanghai"
				height: "100%"
				crossScrollingEnabled: true
				cellDuration: 30
				editing: {
					allowAdding: false,
					allowDragging: false,
					allowResizing: false,
					allowDeleting: false,
					allowUpdating: false,
				},
				appointmentTemplate: _getAppointmentTemplate(view.options)
				onAppointmentClick: (e) ->
					if e.event.currentTarget.className.includes("dx-list-item")
						e.cancel = true

				onAppointmentDblClick: (e) ->
					e.cancel = true

				onAppointmentUpdated: (e)->
					dxSchedulerInstance.option("dataSource", _dataSource(view.options))

				dropDownAppointmentTemplate: (data, index, container) ->
					markup = _getTooltipTemplate(data, view.options);
					markup.find(".read").dxButton({
						text: "查看详细",
						type: "default",
						onClick: (e) ->
							_readData(data)
					});

					markup.find(".edit").dxButton({
						text: "编辑",
						type: "default",
						onClick: (e) ->
							_editData(data)
					});

					markup.find(".delete").dxButton({
						onClick: () ->
							_deleteData(data)
					})

					return markup;
				appointmentTooltipTemplate: (data, index, container) ->
					markup = _getTooltipTemplate(data, view.options);
					markup.find(".read").dxButton({
						text: "查看详细",
						type: "default",
						onClick: () ->
							_readData(data)
					});

					markup.find(".edit").dxButton({
						text: "编辑",
						type: "default",
						onClick: () ->
							_editData(data)
					});

					markup.find(".delete").dxButton({
						onClick: () ->
							_deleteData(data)
					})

					return markup;
			}

			_.extend(dxSchedulerConfig, view.options)

			dxSchedulerInstance =  $("#scheduler").dxScheduler(dxSchedulerConfig).dxScheduler("instance")

			window.dxSchedulerInstance = dxSchedulerInstance;