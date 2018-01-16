Meteor.methods
	archive_receive: (selectedIds,space) ->
		successNum = 0
		collection = Creator.Collections["archive_records"]
		selectedIds.forEach (selectedId)->
			newSuccessNum = collection.update({_id:selectedId},{$set:{is_received:true,received:new Date(),received_by:Meteor.userId()}})
			successNum = successNum+ newSuccessNum
			if newSuccessNum
				Meteor.call("archive_new_audit",selectedId,"接收档案","成功",space)
			else
				Meteor.call("archive_new_audit",selectedId,"接收档案","失败",space)
		return successNum