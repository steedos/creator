xml2js = Npm.require 'xml2js'
fs = Npm.require 'fs'
path = Npm.require 'path'
mkdirp = Npm.require 'mkdirp'

logger = new Logger 'Export_TO_XML'

_writeXmlFile = (jsonObj,object_name) ->
	# 转xml
	builder = new xml2js.Builder()
	xml = builder.buildObject jsonObj

	# 转为buffer
	stream = new Buffer xml

	# 根据当天时间的年月日作为存储路径
	now = new Date
	year = now.getFullYear()
	month = now.getMonth() + 1
	day = now.getDate()

	# 文件路径
	filePath = path.join(__meteor_bootstrap__.serverDir,'../../../export/' + year + '/' + month + '/' + day + '/' + object_name )
	fileName = jsonObj?._id + ".xml"
	fileAddress = path.join filePath, fileName

	if !fs.existsSync filePath
		mkdirp.sync filePath

	# 写入文件
	fs.writeFile fileAddress, stream, (err) ->
		if err
			logger.error "#{jsonObj._id}写入xml文件失败",err


# 整理Fields的json数据
_mixFieldsData = (obj,object_name) ->
	# 初始化对象数据
	jsonObj = {}
	jsonObj._id = obj?._id
	# 获取fields
	objFields = Creator?.Objects[object_name]?.fields

	mixStr = (field_name)->
		jsonObj[field_name] = obj[field_name] || ""

	mixArr = (field_name)->
		jsonObj[field_name] = obj[field_name] || ""

	mixReference = (field,field_name)->
		ref_collection = Creator.Collections[field?.reference_to]
		referenceObj = ref_collection.findOne(_id:obj[field_name],{name:1})
		if referenceObj
			if referenceObj?.name
				mixObj = {
					_id :obj[field_name],
					name : referenceObj?.name
				}
			else
				mixObj = obj[field_name]
		jsonObj[field_name] = mixObj || ""

	mixDate = (field_name,type)->
		date = obj[field_name]
		dateStr = ""
		if date
			if type == "date"
				dateStr = moment(date).format("YYYY-MM-DD")
			else
				dateStr = moment(date).format("YYYY-MM-DD HH:mm:ss")
		jsonObj[field_name] = dateStr

	mixBool = (field_name)->
		if obj[field_name] == true
			jsonObj[field_name] = "是"
		else if obj[field_name] == false
			jsonObj[field_name] = "否"
		else
			jsonObj[field_name] = ""

	# 循环每个fields,并判断取值
	_.each objFields, (field, field_name)->
		switch field?.type
			when "text","textarea","html","select","number" then mixStr field_name
			when "[text]" then mixArr field_name
			when "master_detail","lookup" then mixReference field,field_name
			when "date","datetime" then mixDate field_name,field.type
			when "boolean" then mixBool field_name
	return jsonObj

# Creator.Export2xml()
Creator.Export2xml = (object_name) ->
	logger.info "Run Creator.Export2xml"

	console.time "Creator.Export2xml"

	object_name = "archive_records"
	# 查找对象数据
	collection = Creator.Collections[object_name]

	records = collection.find({}).fetch()

	records.forEach (record)->
			# 整理object格式数据
			jsonObj = _mixFieldsData record,object_name
			# 转为xml保存文件
			_writeXmlFile jsonObj,object_name

	console.timeEnd "Creator.Export2xml"