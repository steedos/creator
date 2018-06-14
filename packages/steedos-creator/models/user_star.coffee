Creator.Objects.user_star =
	name: "user_star"
	label: "收藏"
	icon: "apps"
	fields:
		user:
			label: "用户"
			type: "lookup"
			reference_to: "users"
		star_space:
			label: "店铺"
			type: "lookup"
			reference_to: "spaces"
		star_post:
			label: "文章"
			type: "lookup"
			reference_to: "post"
	list_views:
		all:
			label:"所有"
			columns: ["user", "star_space", "star_post"]
			filter_scope: "space"
	triggers:
		"after.insert.server.store":
			on: "server"
			when: "after.insert"
			todo: (userId, doc)->
				store_id = doc.space
				store_obj = Creator.getCollection("vip_store").findOne({_id: store_id})
				if store_obj._id
					star_count = store_obj.star_count || 0
					star_count++
					Creator.getCollection("vip_store").direct.update({_id: store_obj._id}, {$set: {star_count: star_count}})
		"after.remove.server.store":
			on: "server"
			when: "after.remove"
			todo: (userId, doc)->
				store_id = doc.space
				store_obj = Creator.getCollection("vip_store").findOne({_id: store_id})
				if store_obj._id
					star_count = store_obj.star_count || 0
					star_count--
					Creator.getCollection("vip_store").direct.update({_id: store_obj._id}, {$set: {star_count: star_count}})
	permission_set:
		user:
			allowCreate: true
			allowDelete: true
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: false
		admin:
			allowCreate: true
			allowDelete: true
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: false
		member:
			allowCreate: true
			allowDelete: true
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: false
		guest:
			allowCreate: true
			allowDelete: true
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: false