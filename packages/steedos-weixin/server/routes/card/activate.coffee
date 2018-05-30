JsonRoutes.add 'put', '/api/mini/vip/card_activate', (req, res, next) ->
	try
		spaceId = req.query.space_id

		# #办卡门店
		# storeId = req.query.store_id
		userId = Steedos.getUserIdFromAuthToken(req, res);
		if !userId
			throw new Meteor.Error(500, "No permission")
		card_id = req.query.card_id
		data = req.body
		# 将用户填写的信息同步到user表
		WXMini.updateUser(userId, {
			$set: {
				"profile.sex": data.sex,
				"profile.birthdate": data.birthdate,
				mobile: data.phoneNumber,
				name: data.name
			}
		})

		Creator.getCollection("space_users").direct.update({
			user: userId,
			space: spaceId
		}, {$set: {mobile: data.phoneNumber}})
		if data.price==0
			Creator.getCollection("vip_card").direct.update({_id:card_id},{$set:{is_actived:true,card_name:data.category_id}})
		else
			throw new Meteor.Error 500, "支付完成之后才可激活"
		# doc = {
		# 	user: userId
		# 	space: spaceId
		# 	card_number: card_number
		# 	card_name:data.name
		# 	points: 0
		# 	#grade: "普通"
		# 	#discount: 10.00
		# 	balance: 0.00
		# 	store: storeId
		# 	apply_stores: apply_stores
		# 	start_time: new Date()
		# 	introducer: data.introducer
		# 	owner: userId
		# 	created_by: userId
		# 	modified_by: userId
		# 	created: now
		# 	modified: now
		# 	is_actived: false #默认激活
		# }
		JsonRoutes.sendResult res, {
			code: 200,
			data: {card_id:card_id}
		}
	catch e
		console.error e.stack
		JsonRoutes.sendResult res, {
			code: e.error || 500
			data: {errors: e.reason || e.message}
		}






