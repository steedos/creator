xml2js = Npm.require 'xml2js'
fs = Npm.require('fs')
path = Npm.require('path')
mkdirp = Npm.require('mkdirp')

@Test = {}
# 每次同步的条数
limit_num = 10

saveXmlFile = (obj) ->
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
	objectName = "archive_records"

	# 文件路径
	filePath = path.join(__meteor_bootstrap__.serverDir,'../../../export/' + year + '/' + month + '/' + day + '/' + objectName )
	fileName = obj._id + ".xml"
	fileAddress = path.join filePath, fileName

	if !fs.existsSync filePath
		mkdirp.sync filePath

	# 写入文件
	fs.writeFile fileAddress, stream, (err) ->
		if err
			throw err

# Test.xml()
Test.xml = () ->
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
		objs = db.object.find({},
					{
						sort: { 'created': 1 },
						skip :limit_num * i,
						limit : limit_num
					})

		objs.forEach (obj)->
			# 存储为xml文件
			saveXmlFile obj

		i++

