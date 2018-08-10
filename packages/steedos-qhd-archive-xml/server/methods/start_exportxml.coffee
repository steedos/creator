Meteor.methods
	start_exportxml: (space, record_ids) ->
		try
			if space and record_ids
				exportToXML = new ExportToXML(space, record_ids)
				exportToXML.DoExport()
				return result
		catch e
			error = e
			return error
		