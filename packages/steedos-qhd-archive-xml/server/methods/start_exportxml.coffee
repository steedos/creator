Meteor.methods
	start_exportxml: (space, record_ids) ->
		try
			exportToXML = new ExportToXML(space, record_ids)
			exportToXML.DoExport()
			return result
		catch e
			error = e
			return error
		