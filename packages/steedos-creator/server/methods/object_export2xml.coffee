xml2js = Npm.require 'xml2js'
fs = Npm.require('fs')
path = Npm.require('path')
mkdirp = Npm.require('mkdirp')

logger = new Logger 'Export_TO_XML'

# 每次同步的条数
limit_num = 10

_writeXmlFile = (obj,object_name) ->
	console.log obj
	# 转xml
	builder = new xml2js.Builder()
	xml = builder.buildObject obj

	# 转为buffer
	stream = new Buffer xml

	# 存储到服务器文件夹
	now = new Date
	year = now.getFullYear()
	month = now.getMonth() + 1
	day = now.getDate()

	# 文件路径
	filePath = path.join(__meteor_bootstrap__.serverDir,'../../../export/' + year + '/' + month + '/' + day + '/' + object_name )
	fileName = obj._id + ".xml"
	fileAddress = path.join filePath, fileName

	console.log "======================="
	console.log filePath
	if !fs.existsSync filePath
		mkdirp.sync filePath

	# 写入文件
	fs.writeFile fileAddress, stream, (err) ->
		if err
			console.log err
			logger.error "写入xml文件失败",err


# 整理json数据
_mixJsonData = (obj,object_name) ->
	# 初始化对象数据
	schema = {}
	# 获取fields
	objFields = Creator?.Objects[object_name]?.fields

	mixStr = (field_name)->
		schema[field_name] = obj[field_name] || ""

	mixArr = (field_name)->
		schema[field_name] = obj[field_name] || ""

	mixReference = (field,field_name)->
		db.reference = Creator.Collections[field?.reference_to]
		referenceObj = db.reference.findOne(_id:obj[field_name],{name:1})
		if referenceObj
			mixObj = {
				_id :obj[field_name],
				name : referenceObj?.name
			}
		schema[field_name] = mixObj || ""

	mixDate = (field_name,type)->
		date = obj[field_name]
		dateStr = ""
		if date
			if type = "date"
				dateStr = moment(date).format("YYYY-MM-DD")
			else
				dateStr = moment(date).format("YYYY-MM-DD HH:mm:ss")
		schema[field_name] = dateStr

	mixBool = (field_name)->
		if obj[field_name] == true
			schema[field_name] = "是"
		else if obj[field_name] == false
			schema[field_name] = "否"
		else
			schema[field_name] = ""

	# 循环每个fields,并判断取值
	_.each objFields, (field, field_name)->
		fs = {}
		switch field?.type
			when "text","textarea","html","select","number" then mixStr field_name
			when "[text]" then mixArr field_name
			when "master_detail","lookup" then mixReference field,field_name
			when "date","datetime" then mixDate field_name,field.type
			when "boolean" then mixBool field_name
	return schema

# Creator.Export2xml()
Creator.Export2xml = (object_name) ->
	logger.info "Run Creator.Export2xml"

	console.time "Creator.Export2xml"

	object_name = "archive_records"
	# 查找对象数据
	db.object = Creator.Collections[object_name]

	# 总个数
	total_num = db.object.find({}).count()

	# 同步次数
	times_num = parseInt total_num/limit_num + 1

	i = 0

	# 防止一次查找过多数据，内存溢出，每次限制查找10条记录
	while i < times_num
		# 查找
		objs = db.object.find({_id:'54pvEyFaANHHYb6Tc'},
					{
						sort: { 'created': 1 },
						skip : limit_num * i,
						limit : limit_num
					})
		objs.forEach (obj)->
			# 整理object格式数据
			schemaObj = _mixJsonData obj,object_name
			_writeXmlFile schemaObj,object_name
		# 计数自加1
		i++

	console.timeEnd "Creator.Export2xml"