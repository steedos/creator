request = Npm.require('request')
path = Npm.require('path')
fs = Npm.require('fs')

logger = new Logger 'Records_QHD -> InstancesToArchive'


#	校验必填
_checkParameter = (formData) ->
	if !formData.fonds_name
		return false
	return true

# 整理档案表数据
_minxiInstanceData = (formData, instance) ->
	if !instance
		return
	dateFormat = "YYYY-MM-DD HH:mm:ss"

	formData.space = instance.space

	formData.owner = instance.submitter

	formData.created_by = instance.created_by

	formData.created = new Date()

	# 字段映射:表单字段对应到formData
	field_values = InstanceManager.handlerInstanceByFieldMap(instance)

	formData.applicant_name = field_values?.nigaorens
	formData.document_status = field_values?.guidangzhuangtai
	formData.archive_dept = field_values?.guidangbumen
	formData.applicant_organization_name=field_values?.nigaodanwei || field_values?.FILE_CODE_fzr
	formData.total_number_of_pages = field_values?.PAGE_COUNT
	formData.security_classification = field_values?.miji
	formData.document_type = field_values?.wenjianleixing
	formData.document_date = field_values?.wenjianriqi
	formData.document_number = field_values?.wenjianzihao
	formData.author = field_values?.FILE_CODE_fzr
	formData.title = instance.name

	# 机构：FILING_DEPT字段（发文是拟稿单位，收文是所属部门）
	if field_values?.FILING_DEPT
		orgObj = Creator.Collections["archive_organization"].findOne({'name':field_values?.FILING_DEPT})
	if orgObj
		formData.organizational_structure = orgObj._id

	# 根据FONDSID查找全宗号和全总名称
	fondObj = Creator.Collections["archive_fonds"].findOne({'name':field_values?.FONDSID})
	if fondObj
		formData.fonds_identifier = fondObj?._id
		formData.fonds_name = fondObj?.name

	# 保管期限代码查找
	retentionObj = Creator.Collections["archive_retention"].findOne({'name':field_values?.baocunqixian})
	if retentionObj
		formData.retention_peroid = retentionObj?._id
		# 根据保管期限,处理标志
		if retentionObj?.years >= 10
			formData.produce_flag = "在档"
		else
			formData.produce_flag = "暂存"
	
	# 归档日期
	formData.archive_date = moment(new Date()).format(dateFormat)

	# OA表单的ID，作为判断OA归档的标志
	formData.external_id = instance._id

	fieldNames = _.keys(formData)

	fieldNames.forEach (key)->
		fieldValue = formData[key]
		if _.isDate(fieldValue)
			fieldValue = moment(fieldValue).format(dateFormat)

		if _.isObject(fieldValue)
			fieldValue = fieldValue?.name

		if _.isArray(fieldValue) && fieldValue.length > 0 && _.isObject(fieldValue)
			fieldValue = fieldValue?.getProperty("name")?.join(",")

		if _.isArray(fieldValue)
			fieldValue = fieldValue?.join(",")

		if !fieldValue
			fieldValue = ''

	return formData

# 整理关联档案
_minxiRelatedArchives = (instance, record_id) ->
	# 当前归档的文件有关联的文件
	if instance?.related_instances
		related_archives = []
		instance.related_instances.forEach (related_instance) ->
			relatedObj = Creator.Collections["archive_wenshu"].findOne({'external_id':related_instance},{fields:{_id:1}})
			if relatedObj
				related_archives.push relatedObj?._id
		Creator.Collections["archive_wenshu"].update(
			{_id:record_id},
			{
				$set:{ related_archives:related_archives }
			})

	# 查找当前 instance 是否被其他的 主instance 关联
	mainRelatedObjs = Creator.Collections["instances"].find(
		{'related_instances':instance._id},
		{fields: {_id: 1}}).fetch()
	# 如果被其他的主instance关联该文件，则更新主instance的related_archives字段
	if mainRelatedObjs.length > 0
		mainRelatedObjs.forEach (mainRelatedObj) ->
			# 查找该主 instance对应的主关联档案
			mainRelatedObj = Creator.Collections["archive_wenshu"].findOne({'external_id':mainRelatedObj._id})
			if mainRelatedObj
				related_archives = mainRelatedObj?.related_archives || []
				related_archives.push record_id
				Creator.Collections["archive_wenshu"].update(
					{_id:mainRelatedObj._id},
					{
						$set:{ related_archives:related_archives }
					})

# 整理文件数据
_minxiAttachmentInfo = (instance, record_id) ->
	# 对象名
	object_name = RecordsQHD?.settings_records_qhd?.to_archive?.object_name
	parents = []
	spaceId = instance?.space

	# 查找最新版本的文件(包括正文附件)
	currentFiles = cfs.instances.find({
		'metadata.instance': instance._id,
		'metadata.current': true
	}).fetch()

	collection = Creator.Collections["cms_files"]

	currentFiles.forEach (cf)->
		try
			versions = []
			# 根据当前的文件,生成一个cms_files记录
			cmsFileId = collection._makeNewID()
			
			collection.insert({
					_id: cmsFileId,
					versions: [],
					created_by: cf.metadata.owner,
					size: cf.size(),
					owner: cf?.metadata?.owner,
					modified: cf?.metadata?.modified,
					main: cf?.metadata?.main,
					parent: {
						o: object_name,
						ids: [record_id]
					},
					modified_by: cf?.metadata?.modified_by,
					created: cf?.metadata?.created,
					name: cf.name(),
					space: spaceId,
					extention: cf.extension()
				})

			# 查找每个文件的历史版本
			historyFiles = cfs.instances.find({
				'metadata.instance': cf.metadata.instance,
				'metadata.current': {$ne: true},
				"metadata.parent": cf.metadata.parent
			}, {sort: {uploadedAt: -1}}).fetch()
			# 把当前文件放在历史版本文件的最后
			historyFiles.push(cf)

			# 历史版本文件+当前文件 上传到creator
			historyFiles.forEach (hf) ->
				newFile = new FS.File()
				newFile.attachData(
					hf.createReadStream('instances'),
					{type: hf.original.type},
					(err)->
						if err
							throw new Meteor.Error(err.error, err.reason)
						newFile.name hf.name()
						newFile.size hf.size()
						metadata = {
							owner: hf.metadata.owner,
							owner_name: hf.metadata?.owner_name,
							space: spaceId,
							record_id: record_id,
							object_name: object_name,
							parent: cmsFileId,
							current: hf.metadata?.current
						}
						newFile.metadata = metadata
						fileObj = cfs.files.insert(newFile)
						if fileObj
							versions.push(fileObj._id)
					)
			# 把 cms_files 记录的 versions 更新
			collection.update(cmsFileId, {$set: {versions: versions}})
		catch e
			logger.error "正文附件下载失败：#{cf._id}. error: " + e


# 整理表单html
_minxiInstanceHtml = (instance, record_id) ->
	admin = RecordsQHD?.settings_records_qhd?.to_archive?.admin
	apps_url = RecordsQHD?.settings_records_qhd?.to_archive?.apps_url
	
	space_id = instance?.space
	ins_id = instance?._id

	user_id = admin?.userid
	username = admin?.username
	password = admin?.password

	instance_html_url = apps_url + '/workflow/space/' + space_id + '/view/readonly/' + ins_id + '?username=' + username + '&password=' + password + '&hide_traces=1'

	result_html = HTTP.call('GET',instance_html_url)?.content

	if result_html
		try
			object_name = RecordsQHD?.settings_records_qhd?.to_archive?.object_name

			collection = Creator.Collections["cms_files"]

			cmsFileId = collection._makeNewID()

			date_now = new Date()

			data_buffer = new Buffer(result_html.toString())

			file_name = instance?.name + '.html'

			file_size = data_buffer?.length
		
			collection.insert({
					_id: cmsFileId,
					versions: [],
					size: file_size,
					owner: user_id,
					instance_html: true,
					parent: {
						o: object_name,
						ids: [record_id]
					},
					modified: date_now,
					modified_by: user_id,
					created: date_now,
					created_by: user_id,
					name: file_name,
					space: space_id,
					extention: 'html'
				},
				(error,result)->
					if error
						throw new Meteor.Error(error)
				)

			newFile = new FS.File()
			newFile.attachData(
				data_buffer,
				{type: 'text/html'},
				(err)->
					if err
						throw new Meteor.Error(err.error, err.reason)
					newFile.name file_name
					newFile.size file_size
					metadata = {
						owner: user_id,
						owner_name: "系统生成",
						space: space_id,
						record_id: record_id,
						object_name: object_name,
						parent: cmsFileId,
						instance_html: true
					}
					newFile.metadata = metadata
					fileObj = cfs.files.insert(newFile)
					if fileObj
						versions = []
						versions.push fileObj?._id
						collection.update(cmsFileId, {$set: {versions: versions}})
				)
		catch e
			logger.error "表单生成HTML失败：#{ins_id}. error: " + e


# 整理档案审计数据
_minxiInstanceTraces = (auditList, instance, record_id) ->
	collection = Creator.Collections["archive_audit"]
	# 获取步骤状态文本
	getApproveStatusText = (approveJudge) ->
		locale = "zh-CN"
		#已结束的显示为核准/驳回/取消申请，并显示处理状态图标
		approveStatusText = undefined
		switch approveJudge
			when 'approved'
				# 已核准
				approveStatusText = "已核准"
			when 'rejected'
				# 已驳回
				approveStatusText = "已驳回"
			when 'terminated'
				# 已取消
				approveStatusText = "已取消"
			when 'reassigned'
				# 转签核
				approveStatusText = "转签核"
			when 'relocated'
				# 重定位
				approveStatusText = "重定位"
			when 'retrieved'
				# 已取回
				approveStatusText = "已取回"
			when 'returned'
				# 已退回
				approveStatusText = "已退回"
			when 'readed'
				# 已阅
				approveStatusText = "已阅"
			else
				approveStatusText = ''
				break
		return approveStatusText

	traces = instance?.traces

	traces.forEach (trace)->
		approves = trace?.approves || []
		approves.forEach (approve)->
			auditObj = {}
			auditObj.business_status = "计划任务"
			auditObj.business_activity = trace?.name
			auditObj.action_time = approve?.start_date
			auditObj.action_user = approve?.user
			auditObj.action_description = getApproveStatusText approve?.judge
			auditObj.action_administrative_records_id = record_id
			auditObj.instace_id = instance._id
			auditObj.space = instance.space
			auditObj.owner = approve?.user
			collection.direct.insert auditObj
	autoAudit = {
		business_status: "计划任务",
		business_activity: "自动归档",
		action_time: new Date,
		action_user: "OA",
		action_description: "",
		action_administrative_records_id: record_id,
		instace_id: instance._id,
		space: instance.space,
		owner: ""
	}
	collection.direct.insert autoAudit
	return

# =============================================

# spaces: Array 工作区ID
# contract_flows： Array 合同类流程
InstancesToArchive = (spaces, contract_flows, ins_ids) ->
	@spaces = spaces
	@contract_flows = contract_flows
	@ins_ids = ins_ids
	return

InstancesToArchive.success = (instance)->
	Creator.Collections["instances"].update({_id: instance._id}, {$set: {is_recorded: true}})

InstancesToArchive.failed = (instance, error)->
	logger.error "failed, name is #{instance.name}, id is #{instance._id}. error: ", error

#	获取非合同类的申请单：正常结束的(不包括取消申请、被驳回的申请单)
InstancesToArchive::getNonContractInstances = ()->
	query = {
		space: {$in: @spaces},
		flow: {$nin: @contract_flows},
		# is_archived 字段被老归档接口占用，所以使用 is_recorded 字段判断是否归档
		# 正常情况下，未归档的表单无 is_recorded 字段
		$or: [
			{is_recorded: false},
			{is_recorded: {$exists: false}}
		],
		is_deleted: false,
		state: "completed",
		"values.record_need": "true"
		# 重定位到结束的表单该值为 terminated，故取消此判断
		# $or: [
		# 	{final_decision: "approved"},
		# 	{final_decision: {$exists: false}},
		# 	{final_decision: ""}
		# ]
	}
	if @ins_ids
		query._id = {$in: @ins_ids}
	return Creator.Collections["instances"].find(query, {fields: {_id: 1}}).fetch()


InstancesToArchive.syncNonContractInstance = (instance, callback) ->
	#	表单数据
	formData = {}

	# 审计记录
	auditList = []

	_minxiInstanceData(formData, instance)

	if _checkParameter(formData)
		logger.debug("_sendContractInstance: #{instance._id}")

		# 如果原来已经归档，则删除原来归档的记录
		collection = Creator.Collections["archive_wenshu"]

		collection.remove({'external_id':instance._id})

		record_id = collection.insert formData

		# 整理文件
		_minxiAttachmentInfo(instance, record_id)

		# 整理表单html
		_minxiInstanceHtml(instance, record_id)

		# 整理关联档案
		_minxiRelatedArchives(instance, record_id)

		# 处理审计记录
		_minxiInstanceTraces(auditList, instance, record_id)

		InstancesToArchive.success instance
	else
		InstancesToArchive.failed instance, "立档单位 不能为空"


@Test = {}
# Test.run('rJxkv4CPfgz598rRD')
Test.run = (ins_id)->
	instance = Creator.Collections["instances"].findOne({_id: ins_id})
	if instance
		InstancesToArchive.syncNonContractInstance instance

InstancesToArchive::syncNonContractInstances = () ->
	console.time("syncNonContractInstances")
	instances = @getNonContractInstances()

	that = @
	try
		instances.forEach (mini_ins)->
			console.log "----------",mini_ins?._id
			instance = Creator.Collections["instances"].findOne({_id: mini_ins._id})
			if instance
				InstancesToArchive.syncNonContractInstance instance

	catch e
		error = e
		console.log "---------error---", e
	
	console.timeEnd("syncNonContractInstances")