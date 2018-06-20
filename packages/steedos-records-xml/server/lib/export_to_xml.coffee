xml2js = Npm.require 'xml2js'
fs = Npm.require 'fs'
path = Npm.require 'path'
mkdirp = Npm.require 'mkdirp'

logger = new Logger 'QHD_Export_TO_XML'

Export2XML = {}

# Export2XML.export2xml("fHgmzuMGrWB6QMWDM")
Export2XML.export2xml = (_id) ->

	result_obj = Export2XML.encapsulation(_id)

	if result_obj

		Creator.Collections["archive_wenshu"].update(
			{_id:_id},
			{
				$set:{ has_xml:true }
			})

		console.log "======================"

		console.log result_obj

		# 转xml
		builder = new xml2js.Builder()
		xml_obj = builder.buildObject result_obj

		# 转为buffer
		stream = new Buffer xml_obj

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

		# 写入文件
		fs.writeFile fileAddress, stream, (err) ->
			if err
				logger.error "#{jsonObj._id}写入xml文件失败",err