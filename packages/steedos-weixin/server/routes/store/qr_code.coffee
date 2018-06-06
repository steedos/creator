request = Npm.require("request")
base64 = Npm.require('base-64');
fs = Npm.require 'fs'

getAccessToken = (appId,secret,cb)->
	request.get {
		url:"https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{appId}&secret=#{secret}"
	},(err,httpResponse,body)->
		cb err, httpResponse, body
		if err
			console.error('get access_token failed:', err)
			return
		if httpResponse.statusCode ==200
			console.log body,"3333"
			return body['access_token']

getAccessTokenAsync = Meteor.wrapAsync(getAccessToken);

WebApp.connectHandlers.use '/api/steedos/weixin/code', (req, res, next) ->
	try
		# appId = req.headers["appid"]
		userId = Steedos.getUserIdFromAuthToken(req, res)
		appId = "wx89eb02efdb4ddaaf"
		secret = "03937733e0ab47685080fbb81c0a5459"
		# secret = Meteor.settings.weixin.appSecret[appId]
		console.log "appId,secret"
		console.log appId,secret
		if !secret
			throw new Meteor.Error(500, "无效的appId #{appId}")
		resData = getAccessTokenAsync appId, secret
		wxToken = JSON.parse(resData.body)
		if wxToken?.access_token
			formData = {
				path: "pages/index"
				width: 10
			}

			requestSettings = {
				url: "https://api.weixin.qq.com/wxa/getwxacode",
				method: 'POST',
				encoding: null,
				qs: { access_token: wxToken.access_token },
				form: false,
				body: JSON.stringify(formData)
			}

			request requestSettings, (error, response, body) ->
				if error
					console.error error
					res.end()
					return

				console.log body
				res.setHeader('Content-type', 'image/jpeg')
				# res.setHeader('content-disposition', 'attachment; filename=aaa.jpg')
				res.end(body)

	catch e
		console.error e.stack
		JsonRoutes.sendResult res, {
			code: e.error
			data: {errors: e.reason || e.message}
		}
