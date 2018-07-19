Meteor.methods
	init_statistics: (spaces, need_recorded_flows, ins_ids) ->
		try
			instancesToArchive = new InstancesToArchive(spaces, need_recorded_flows, ins_ids)
	        instancesToArchive.syncInstances()
			return result
		catch e
			error = e
			return error