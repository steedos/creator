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
		"original.name":
			label:"名称"
			type: "text"
			is_name:true
		"original.size":
			label:"文件大小"
			type: "number"
		metadata:
			label:"文件属性"
			type: "object"
			blackbox: true
			omit: true
		"metadata.owner":
			label:"上传者"
			type: "lookup"
			reference_to: "users"
			omit: true
		"metadata.parent":
			label:"所属文件"
			type: "master_detail"
			reference_to: "cms_files"
		uploadedAt: 
			label:"上传时间"
			type: "datetime"
		created_by:
			hidden: true
		modified_by:
			hidden: true

	list_views:
		all:
			filter_scope: "space"
			# columns: ["original.name","original.size","metadata.owner_name","uploadedAt"]
			columns: ["uploadedAt"]
	
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