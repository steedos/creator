Meteor.methods
	syncSpaceUserCompany: (spaceId, user_ids) ->
		try
			console.log "spaceId, user_ids========",spaceId, user_ids
			if spaceId and user_ids
				console.log "11111111"
				syncSpaceUserCompany = new SyncSpaceUserCompany(spaceId, user_ids)
				console.log "22222222"
				syncSpaceUserCompany.DoSync()
				return result
			else
                return 'No spaceid or userids!'
		catch e
			error = e
			return error
		