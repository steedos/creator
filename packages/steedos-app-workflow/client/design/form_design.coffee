Template.formDesign.helpers
	form: ()->
		return Creator.odata.get("forms", Template.instance().data.formId)

Template.formDesign.events
	'click .btn-confirm': (e, t)->
		console.log('click .btn-confirm');

		data = $("#fb-editor").data('formBuilder').actions.getData()
		formFields = Creator.formBuilder.transformFormFieldsOut(data)

		validate = Creator.formBuilder.validateFormFields formFields

		if !validate
			return

		form = Creator.odata.get("forms", t.data.formId)

		form.current.fields = formFields

		console.log('formFields', formFields)

		url = "#{Meteor.settings.public.webservices.workflowDesigner.url}am/forms?sync_token=#{(new Date()).getTime() / 1000}"
		console.log('url', url)
		data = {}
		form.id = form._id
		data['Forms'] = [form]
		$.ajax
			type: "put"
			url: url
			data: JSON.stringify(data)
			dataType: 'json'
			contentType: "application/json"
			processData: false
			beforeSend: (request) ->
				request.setRequestHeader('X-User-Id', Meteor.userId())
				request.setRequestHeader('X-Auth-Token', Accounts._storedLoginToken())

			success: (data) ->
				console.log('data', data)

			error: (jqXHR, textStatus, errorThrown) ->
				if jqXHR.status == 504
					toastr?.error?(TAPi18n.__('连接超时，请稍后再试'))
				else
					error = jqXHR.responseJSON.error
					console.error error
					if error.reason
						toastr?.error?(TAPi18n.__(error.reason))
					else if error.message
						toastr?.error?(TAPi18n.__(error.message))
					else
						toastr?.error?(error)