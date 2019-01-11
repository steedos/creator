Creator.Objects.cms_files =
	name: "cms_files"
	label: "附件"
	icon: "drafts"
	enable_search: true
	enable_api: true
	hidden: true
	fields:
		name:
			label: "名称"
			type: "text"
			searchable:true
			index:true
			is_wide: true
		description:
			label: "描述"
			type: "textarea"
			hidden: true
			is_wide: true
		extention:
			label: "文件后缀"
			type: "text"
			readonly: true
			omit: true
		size:
			label: "文件大小"
			type: "filesize"
			omit: true
			readonly: true
		versions:
			label: "历史版本"
			type: "file"
			collection: "files"
			multiple: true
			omit: true
			hidden: true
		parent:
			label: "所属记录"
			type: "lookup"
			omit: true
			reference_to: ()->
				return _.keys(Creator.Objects)

	list_views:
		all:
			columns: ["name", "size", "owner", "created", "modified"]
			extra_columns: ["versions"]
			order: [[4, "asc"]]
			filter_scope: "space"

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
			allowDelete: true
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true

	triggers:
		"before.remove.server.default":
			on: "server"
			when: "before.remove"
			todo: (userId, doc)->
				collection = cfs.files
				collection.remove {"metadata.parent": doc._id}

	actions:
		standard_edit:
			label: "编辑"
			sort: 0
			visible: (object_name, record_id, record_permissions)->
				if object_name == Session.get('object_name')
					fileRecord = Creator.getObjectRecord()
					record = Creator.getObjectRecord(fileRecord.parent.o, fileRecord.parent.ids[0])
					if record && record.locked
						return false
				else
					record = Creator.getObjectRecord()
					if record && record.locked
						return false

				if record_permissions
					return record_permissions["allowEdit"]
				else
					record_permissions = Creator.getRecordPermissions object_name, record, Meteor.userId()
					if record_permissions
						return record_permissions["allowEdit"]
			on: "record"
			todo: "standard_edit"

		standard_delete:
			label: "删除"
			visible: (object_name, record_id, record_permissions)->
				if object_name == Session.get('object_name')
					fileRecord = Creator.getObjectRecord()
					record = Creator.getObjectRecord(fileRecord.parent.o, fileRecord.parent.ids[0])
					if record && record.locked
						return false
				else
					record = Creator.getObjectRecord()
					if record && record.locked
						return false

				if record_permissions
					return record_permissions["allowDelete"]
				else
					record_permissions = Creator.getRecordPermissions object_name, record, Meteor.userId()
					if record_permissions
						return record_permissions["allowDelete"]
			on: "record_more"
			todo: "standard_delete"
		download:
			label: "下载"
			visible: true
			on: "record"
			todo: (object_name, record_id)->
				file = this.record
				fileId = file?.versions?[0]
				if fileId
					if Meteor.isCordova
						url = Steedos.absoluteUrl("/api/files/files/#{fileId}")
						filename = file.name
						rev = fileId
						length = file.size
						Steedos.cordovaDownload(url, filename, rev, length)
					else
						window.location = Steedos.absoluteUrl("/api/files/files/#{fileId}?download=true")

		# new_version:
		# 	label: "上传新版本"
		# 	visible: true
		# 	only_detail: true
		# 	is_file: true
		# 	on: "record"
		# 	todo: (object_name, record_id)->
				# 功能代码在文件详细界面，这里只是把按钮显示出来