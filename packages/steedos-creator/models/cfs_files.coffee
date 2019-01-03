Creator.Objects["cfs.files.filerecord"] = 
	name: "cfs.files.filerecord"
	label: "文件版本"
	icon: "drafts"
	enable_search: true
	enable_api: true
	hidden: true
	fields:
		original:
			label:"原始信息"
			type: "object"
			blackbox: true
			omit: true
			hidden: true
		"original.$.name":
			label:"名称"
			type: "text"
		"original.$.size":
			label:"文件大小"
			type: "text"
		metadata:
			label:"文件属性"
			type: "object"
			blackbox: true
			omit: true
			hidden: true
		"metadata.$.owner_name":
			label:"上传者"
			type: "text"
		uploadedAt: 
			label:"上传时间"
			type: "datetime"
		"metadata.$.parent":
			label:"所属文件"
			type: "master_detail"
			reference_to: "cms_files"


	list_views:
		all:
			filter_scope: "space"
			columns: ["original.$.name","original.$.size","metadata.$.owner_name","uploadedAt"]
	permission_set:
		user:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true 
		admin:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true 

	actions:
		download:
			label: "下载"
			visible: true
			on: "record"
			todo: (object_name, record_id)->
				file = this.record
				fileId = record_id
				if fileId
					if Meteor.isCordova
						url = Steedos.absoluteUrl("/api/files/files/#{fileId}")
						filename = file?.original?.name
						rev = fileId
						length = file?.original?.size
						Steedos.cordovaDownload(url, filename, rev, length)
					else
						window.location = Steedos.absoluteUrl("/api/files/files/#{fileId}?download=true")