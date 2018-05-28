JsonRoutes.add 'put', '/mini/vip/user', (req, res, next) ->
	try
		userId = Steedos.getUserIdFromAuthToken(req, res);
		if !userId
			throw new Meteor.Erro(500, "No permission")

		data = req.body

		if !data.name
			throw new Meteor.Erro(500, "姓名为必填")

		if !data.phoneNumber
			throw new Meteor.Erro(500, "手机号为必填")

		# 将用户填写的信息同步到user表
		Creator.getCollection("users").direct.update({_id: userId}, {
			$set: {
				"profile.sex": data.sex,
				"profile.birthdate": data.birthdate,
				mobile: data.phoneNumber,
				name: data.name
			}
		})
		Creator.getCollection("space_users").direct.update({
			user: userId
		}, {$set: {mobile: data.phoneNumber}}, {multi: true})

		JsonRoutes.sendResult res, {
			code: 200,
			data: {}
		}
	catch e
		console.error e.stack
		JsonRoutes.sendResult res, {
			code: e.error || 500
			data: {errors: e.reason || e.message}
		}