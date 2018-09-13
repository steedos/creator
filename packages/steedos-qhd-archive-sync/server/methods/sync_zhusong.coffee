Meteor.methods
	sync_zhusong: (spaces, record_ids) ->
		try
			if spaces and record_ids
				query = {
					space: {$in: spaces},
					external_id: {$exists: true}
				}
				if record_ids?.length > 0
					query._id = { $in: record_ids }
				
				record_objs = Creator.Collections["archive_wenshu"].find(query, {fields: {_id: 1,external_id: 1}}).fetch()
				record_objs.forEach (record_obj)->
					instance = Creator.Collections["instances"].findOne({_id: record_obj.external_id}, {fields: {values: 1}})
					if instance
						zhusong = instance?.values["主送"] || ""
						if instance?.values["页数"]
							yeshu = parseInt(instance?.values["页数"])+1
						else
							yeshu = 1
						Creator.Collections["archive_wenshu"].update(
							{_id: record_obj._id}, {
							$set: {
								prinpipal_receiver: zhusong,
								total_number_of_pages: yeshu
								}})
				return 'success'
			else
				return 'No spaces and record_ids'
		catch e
			error = e
			return error