request = Npm.require("request")

getWeiXinSession = (appId, secret, code, cb)->
	request.get {
		url: "https://api.weixin.qq.com/sns/jscode2session?appid=#{appId}&secret=#{secret}&js_code=#{code}&grant_type=authorization_code"
	}, (err, httpResponse, body)->
		cb err, httpResponse, body
		if err
			console.error('upload failed:', err)
			return
		if httpResponse.statusCode == 200
			return

getWeiXinSessionAsync = Meteor.wrapAsync(getWeiXinSession);

setNewToken = (userId, appId, openid, sessionKey)->
	authToken = Accounts._generateStampedLoginToken()
	token = authToken.token
	hashedToken = Accounts._hashStampedToken authToken
	hashedToken.app_id = appId
	hashedToken.open_id = openid
	hashedToken.session_key = sessionKey
	hashedToken.token = token
	Accounts._insertHashedLoginToken userId, hashedToken
	return token

#TODO 处理unionid
JsonRoutes.add 'post', '/mini/vip/sso', (req, res, next) ->
	try
		code = req.query.code
		old_user_id = req.query.old_user_id
		old_auth_token = req.query.old_auth_token

		appId = req.headers["appid"]

		secret = Meteor.settings.weixin.appSecret[appId]
		if !secret
			  throw new Meteor.Error(500, "无效的appId #{appId}")

		if !code
			  throw new Meteor.Error(401, "miss code")

		resData = getWeiXinSessionAsync appId, secret, code

		wxSession = JSON.parse(resData.body)

		sessionKey = wxSession.session_key

		openid = wxSession.openid

		#	unionid = wxSession.unionid

		if !openid
			  throw new Meteor.Error(401, "miss openid")

		if openid
			  user_openid = Creator.getCollection("users").findOne({
				  "services.weixin.openid.appid": appId,
				  "services.weixin.openid._id": openid
			  }, {fields: {_id: 1}})

			  if !user_openid
				  name = (new Date()).getTime() + "_" + _.random(0, 100)
				  unionid = ""
				  locale = "zh-cn"
				  phoneNumber = ""
				  userId = WXMini.newUser(appId, openid, unionid, name, locale, phoneNumber)

				  authToken = setNewToken(userId, appId, openid, sessionKey)

				  JsonRoutes.sendResult res, {
					  code: 200,
					  data: {
						  open_id: openid
						  user_id: userId
						  auth_token: authToken
					  }
				  }
				  return
			  else
				  if user_openid._id == old_user_id
					  if Steedos.checkAuthToken(old_user_id, old_auth_token)
						  JsonRoutes.sendResult res, {
							  code: 200,
							  data: {
								  open_id: openid
								  user_id: old_user_id
								  auth_token: old_auth_token
							  }
						  }
						  return
					  else
						  authToken = setNewToken(old_user_id, appId, openid, sessionKey)
						  JsonRoutes.sendResult res, {
							  code: 200,
							  data: {
								  open_id: openid
								  user_id: old_user_id
								  auth_token: authToken
							  }
						  }
						  return
				  else
					  authToken = setNewToken(user_openid._id, appId, openid, sessionKey)
					  JsonRoutes.sendResult res, {
						  code: 200,
						  data: {
							  open_id: openid
							  user_id: user_openid._id
							  auth_token: authToken
						  }
					  }
					  return
	catch e
		console.error e.stack
		JsonRoutes.sendResult res, {
			code: e.error
			data: {errors: e.reason || e.message}
		}


