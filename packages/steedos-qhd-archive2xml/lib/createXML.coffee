fs = Npm.require 'fs'
xml2js = Npm.require 'xml2js'

# 正文附件上传
collection = cfs.files


# Archive2XML.createXML()
Archive2XML.createXML = ()->
	obj = {name: "张郎朗", Surname: "男", age: 23}

	builder = new xml2js.Builder()

	xml = builder.buildObject obj

	newFile = new FS.File()

	newFile.name "文件.xml"

	stream = fs.createReadStream xml.toString

	newFile.attachData stream, {type: 'text/xml'},(err) ->
		if err
			throw new Meteor.Error(err.error, err.reason)
		fileObj = collection.insert newFile
		if fileObj
			console.log fileObj
			return fileObj
		else
			return null
			logger.error "文件上传失败：#{f._id},#{f.name()}. error: "

