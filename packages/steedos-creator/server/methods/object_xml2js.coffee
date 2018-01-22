xml2js = Npm.require 'xml2js'

@Test = {}

# Test.xml()
Test.xml = () ->
	# 查找对象数据
	db.archive_records = Creator.Collections["archive_records"]
	obj = db.archive_records.findOne({'_id':'54pvEyFaANHHYb6Tc'})

	# 转xml
	builder = new xml2js.Builder()
	xml = builder.buildObject obj

	# 转为buffer
	stream = new Buffer xml

	# 上传
	newFile = new FS.File()

	newFile.name "metadata.xml"

	newFile.attachData stream, {type: 'text/xml'}, (err) ->
		if err
			throw new Meteor.Error(err.error, err.reason)

		fileObj = cfs.files.insert newFile
		
		if fileObj
			console.log fileObj?._id
		else
			return null
			logger.error "文件上传失败：#{f._id},#{f.name()}. error: "



Meteor.methods
	record_xml: (object_name) ->
		collection = Creator.Collections[object_name]

		# 查找对象数据
		obj = collection.findOne({'_id':'54pvEyFaANHHYb6Tc'})

		# 查找对象数据的所有子表数据
		# (暂未开发)

		builder = new xml2js.Builder()

		xml = builder.buildObject obj

		console.log xml

		newFile = new FS.File()

		newFile.name "FFFFFF.xml"

		stream = new Buffer xml

		console.log "---------------------"

		console.log stream


		return "aaaaaaaaa"

