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
			return body['access_token']

getAccessTokenAsync = Meteor.wrapAsync(getAccessToken);

WebApp.connectHandlers.use '/api/steedos/weixin/code', (req, res, next) ->
	try
		appId = req.headers["appid"]
		userId = Steedos.getUserIdFromAuthToken(req, res)
		secret = Meteor.settings.weixin.appSecret[appId]
		storeId = req.body.store_id
		path = req.body.path
		width = req.body.width
		console.log "path====",path
		console.log "spaceId===",req.body.store_id
		appId = "wx89eb02efdb4ddaaf"
		secret = "03937733e0ab47685080fbb81c0a5459"
		#console.log req 
		if !secret
			throw new Meteor.Error(500, "无效的appId #{appId}")
		resData = getAccessTokenAsync appId, secret
		wxToken = JSON.parse(resData.body)
		if wxToken?.access_token
			formData = {
				path: path
				width: 430
			}

			requestSettings = {
				url: "https://api.weixin.qq.com/cgi-bin/wxaapp/createwxaqrcode?access_token=",
				method: 'POST',
				encoding: null,
				qs: { access_token: wxToken.access_token },
				form: false,
				body: JSON.stringify(formData)
			}

			request requestSettings, Meteor.bindEnvironment((error, response, body) ->
				if error
					console.error error
					res.end()
					return
				
				collection = cfs.images
				imageFile = new FS.File()
				imageFile.attachData body, { type: "image/jpeg" }

				imageFile.name(storeId + ".jpg")
				metadata = {
					owner :userId
				}
				imageFile.owner = userId
				imageFile.metadata = metadata
				console.log imageFile
				#imageFile.metadata = metadata
				collection.insert imageFile,(error,result)->
					Creator.getCollection("vip_store").direct.update(_id:storeId,{$set:qrcode:imageFile._id})
				#res.setHeader('Content-type', 'image/jpeg')
				res.end(imageFile._id)
			)
	catch e
		console.error e.stack
		JsonRoutes.sendResult res, {
			code: e.error
			data: {errors: e.reason || e.message}
		}
