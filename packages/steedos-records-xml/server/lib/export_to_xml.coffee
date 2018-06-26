xml2js = Npm.require 'xml2js'
fs = Npm.require 'fs'
path = Npm.require 'path'
mkdirp = Npm.require 'mkdirp'
NodeRSA = Npm.require 'node-rsa'

logger = new Logger 'QHD_Export_TO_XML'

Export2XML = {}

# Export2XML.export2xml("WoZpCZ3HHyZpxnodG")
Export2XML.export2xml = (_id) ->

	# 封装被签名对象
	bqmdx_json = Export2XML.encapsulation(_id)

	if bqmdx_json
		# 转xml
		builder = new xml2js.Builder()
		# 被签名对象
		bqmdx_xml = builder.buildObject bqmdx_json

		# 生成签名
		private_key_file = Meteor.settings?.records_xml?.archive?.private_key_file
		if private_key_file
			buffer_bqmdx = new Buffer bqmdx_xml

			# key
			readStream = fs.readFileSync private_key_file,{encoding:'utf8'}
			key = new NodeRSA(readStream,'pkcs8');

			# 签名
			# 参数1：需要签名的数据
			# 参数2：加密后返回的格式
			# 参数3：签名数据编码
			signature = key.sign(buffer_bqmdx, 'base64', 'utf8');
			console.log "signature",signature

			# 电子签名
			qmbsf = "修改0-签名1"
			qmgz = "base64"
			qmsj = new Date
			qmr = Meteor.settings?.records_xml?.archive?.signaturer || ""
			qmsfbs = "sha1WithRSAEncryption"
			zsk = []
			public_key_file = Meteor.settings?.records_xml?.archive?.public_key_file
			if public_key_file
				zs = fs.readFileSync public_key_file,{encoding:'utf8'}
				zsyz = ""
				zs_obj = {
					"证书": zs,
					"证书引证": zsyz
				}
				zsk.push zs_obj
			dzqm_json = {
				"签名标识符": qmbsf,
				"签名规则": qmgz,
				"签名时间": qmsj.toISOString(),
				"签名人": qmr,
				"签名结果": signature,
				"证书块": zsk,
				"签名算法标识": qmsfbs
			}
			
			DZWJFZB = {
				"封装包格式描述": "本EEP根据中华人民共和国档案行业标准DA/T HGWS《基于XML的电子文件封装规范》生成",
				"版本": "2018",
				"被签名对象": bqmdx_json,
				"电子签名": dzqm_json
			}

			xml = builder.buildObject DZWJFZB
			
			stream = new Buffer xml

			# # 验证
			# 参数1：被签名的内容
			# 参数2：签名结果
			# 参数3：被签名对象的编码格式
			# 参数4：签名的编码格式
			result = key.verify(buffer_bqmdx, signature, 'utf8', 'base64')
			console.log "result",result

			# 根据当天时间的年月日作为存储路径
			now = new Date
			year = now.getFullYear()
			month = now.getMonth() + 1
			day = now.getDate()

			# 文件路径
			filePath = path.join(__meteor_bootstrap__.serverDir,'../../../export/' + year + '/' + month + '/' + day )
			fileName = "标准封装XML.xml"
			fileAddress = path.join filePath, fileName

			if !fs.existsSync filePath
				mkdirp.sync filePath

			# 写入文件Meteor.bindEnvironment(InstancesStat.run)
			fs.writeFile fileAddress, stream, Meteor.bindEnvironment(
				(err) ->
					if err
						logger.error "#{jsonObj._id}写入xml文件失败",err
					else
						Creator.Collections["archive_wenshu"].update(
							{_id:_id},
							{
								$set:{ has_xml:true }
							})
				)