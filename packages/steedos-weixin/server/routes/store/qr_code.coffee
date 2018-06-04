request = Npm.require("request")
getAccessToken = (appId,secret)->
	request.get {
		url:"https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{appId}&secret=#{secret}"
	},(err,httpResponse,body)->
		console.log "22222"
		if err
			console.error('get access_token failed:', err)
			return
		if httpResponse.statusCode ==200
			console.log body,"3333"
			return body['access_token']



getAccessTokenAsync = Meteor.wrapAsync(getAccessToken);

JsonRoutes.add 'post', '/api/steedos/weixin/code', (req, res, next) ->
	try
		appId = req.headers["appid"]
		secret = Meteor.settings.weixin.appSecret[appId]
		console.log "appId,secret"
		console.log appId,secret
		if !secret
			throw new Meteor.Error(500, "无效的appId #{appId}")
		
		request.get {
			url:"https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{appId}&secret=#{secret}"
		},(err,httpResponse,body)->
			console.log "22222"
			if err
				console.error('get access_token failed:', err)
				return
			if httpResponse.statusCode ==200
				bodyObj = JSON.parse(body)
				access_token = bodyObj['access_token']
				console.log "body======",body
		#access_token = getAccessTokenAsync appId,secret
				console.log "access_token:",access_token
				data = {
						path: "pages/index"
					} 
				request.post {
					url: "https://api.weixin.qq.com/wxa/getwxacode?access_token=#{access_token}",
					data:data
				},(err, httpResponse, body)->
					if err
						console.error('get qrcode failed:', err)
						return
					console.log httpResponse.statusCode
					if httpResponse.statusCode == 200
						console.log "11111"
						console.log body
						JsonRoutes.sendResult res, {
							code: 200,
							data: {"1111":"11111"}
						}
						return body
	catch e
		console.error e.stack
		JsonRoutes.sendResult res, {
			code: e.error
			data: {errors: e.reason || e.message}
		}
