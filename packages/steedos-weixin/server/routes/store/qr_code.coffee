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
				path: "pages/index",
	#			scene:1011,
				width:430,
				auto_color:false,
				line_color:{"r":"0","g":"0","b":"0"},
				is_hyaline:false
				}
			options = { 
				method: 'POST',
				url: 'https://api.weixin.qq.com/wxa/getwxacode',
				qs: { access_token: wxToken.access_token },
				form: false,
				data: JSON.stringify(formData),
			}
			
			HTTP.call('POST',"https://api.weixin.qq.com/wxa/getwxacode?access_token=#{wxToken.access_token}",
				{
					headers: {
					"Content-Type": "application/json"
					},
					data: formData
				}, (error, result)->
						if error
							throw new Error(error)
							return
						else
							console.log(typeof result)
							console.log result
							#aaa = Buffer.from(body).toString()
		#					console.log aaa
							res.setHeader('Content-type', 'image/jpeg')
							res.setHeader('content-disposition', 'attachment; filename="_pages/index"')
							# res.write(body, "binary")
							res.end(result.content)
							return
				)
			
			# HTTP.call(options, (error, response, body)->
			# 	if error 
			# 		throw new Error(error)
			# 	else
			# 		console.log(typeof body)
			# 		aaa = Buffer.from(body).toString()
			# 		console.log aaa
			# 		# res.setHeader('Content-type', 'image/jpeg')
			# 		# res.setHeader('Content-Disposition', 'attachment;filename=index.jpg')
			# 		# res.write(body, "binary")
			# 		res.end(aaa)
			# 		return
			# 	)
			# 		# if error
					# 	console.log "get code failed..."
					# 	return 
					# else
					# 	# collection = cfs.images
					# 	# imageFile = new FS.File()
					# 	# qrcode = result.content
					# 	# imageFile.attachData(Buffer.from(qrcode, "Unicode"), {
					# 	# 	type: "image/jpeg"
					# 	# }, (error,result)->
					# 	# 		if error 
					# 	# 			throw new Meteor.Error(error.error, error.reason)								
					# 	# 		else
					# 	# 			imageFile.name("1111" + ".jpg")
					# 	# 			imageFile.size(qrcode.length)
					# 	# 			metadata = {
					# 	# 				owner :userId
					# 	# 			}
					# 	# 			imageFile.owner = userId
					# 	# 			imageFile.metadata = metadata
					# 	# 			#imageFile.metadata = metadata
					# 	# 			fileObj = collection.insert(imageFile)
					# 	# 			console.log fileObj._id
					# 	# 	# fileObj.update({
					# 	# 	# 	$set: {
					# 	# 	# 		'metadata.parent': fileObj._id
					# 	# 	# 	}
					# 	# 	# })
					# 	# )
					# 	#ws = fs.createWriteStream(result.content,"/doc/images")
					# #	console.log result.content
					# 	JsonRoutes.sendResult res, {
					# 		data: result
					# 	}
				#)
	catch e
		console.error e.stack
		JsonRoutes.sendResult res, {
			code: e.error
			data: {errors: e.reason || e.message}
		}
