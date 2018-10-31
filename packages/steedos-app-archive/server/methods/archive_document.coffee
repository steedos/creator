Meteor.methods
	archive_view: (object_id) ->
		url = ""
		html = Creator.Collections["cfs.files.filerecord"].findOne({
			"metadata.record_id":object_id,"metadata.instance_html": true},
			{fields: {_id: 1}}
			)
		
		if html
			url = Steedos.absoluteUrl("api/files/files/") + html._id

		return url