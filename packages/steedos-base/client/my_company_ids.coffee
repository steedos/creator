Meteor.startup ->
	Tracker.autorun ->
		spaceId = Session.get("spaceId")
		userId = Meteor.userId()
		options =
			$filter: "user eq '#{userId}'",
			$select:'company_id,company_ids'
		Creator.odata.query 'space_users', options, true, (result, error)->
			if result and result.length
				Session.set "user_company_id", result[0].company_id
				Session.set "user_company_ids", result[0].company_ids
