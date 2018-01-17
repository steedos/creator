Meteor.methods
	archive_destroy: (selectedIds,space) ->
		successNum = 0
		collection = Creator.Collections["archive_records"]
		selectedIds.forEach (selectedId)->	
			newSuccessNum = collection.update({_id:selectedId},{$set:{is_destroyed:true,destroyed_by:Meteor.userId(),destroyed:new Date()}})
			successNum = successNum+ newSuccessNum
			if newSuccessNum
				Meteor.call("archive_new_audit",selectedId,"销毁档案","成功",space)
			else
				Meteor.call("archive_new_audit",selectedId,"销毁档案","失败",space)
		return successNum