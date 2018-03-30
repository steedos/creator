Creator.Objects.archive_transfer = 
	name: "archive_transfer"
	icon: "product_item"
	label: "移交"
	enable_search: true
	fields:
		transfer_title:
			type:"text"
			label:"标题"
			is_name:true
			is_wide:true
			required:true
			searchable:true
			index:true
		transfer_category:
			type: "select"
			label:"档案门类"
			options: [
				{label: "文书档案", value: "archive_wenshu"},
				{label: "科技档案", value: "archive_keji"},
				{label: "科技底图", value: "archive_kejiditu"},
				{label: "会计档案", value: "archive_kuaiji"},
				{label: "荣誉档案", value: "archive_rongyu"},
				{label: "声像档案", value: "archive_shengxiang"},
				{label: "电子档案", value: "archive_dianzi"},
				{label: "审计档案", value: "archive_shenji"}
			]
			allowedValues:["archive_wenshu","transfer_category","archive_keji","archive_kejiditu","archive_kuaiji","archive_rongyu","archive_shengxiang","archive_dianzi","archive_shenji"]
			required: true
		transfer_reason:
			label:"移交原因"
			type:"textarea"
			is_wide:true
		transfer_state:
			type:"text"
			label:"移交状态"
			defaultValue:"未移交"
			omit:true
		transfer_time:
			type:"datetime"
			label:"移交时间"
			omit:true
		transfer_by:
			type: "lookup"
			label:"移交人"
			reference_to: "users"
			omit: true
	list_views:
		default:
			columns:["transfer_title","transfer_reason","transfer_state","transfer_time","transfered_by"]
		all:
			label: "全部"
			filter_scope: "space"
			#filters: [["is_received", "$eq", true]] results: { $elemMatch: { $gte: 80, $lt: 85 } }
	triggers:
		"before.insert.server.default": 
			on: "server"
			when: "before.insert"
			todo: (userId, doc)->
				doc.transfer_state = "未移交"
	permission_set:
		user:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: false
			modifyAllRecords: false
			viewAllRecords: false 
		admin:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: false
			modifyAllRecords: false
			viewAllRecords: false 
	actions: 
		receive:
			label:"执行移交"
			visible: true
			on:"record"
			todo:(object_name, record_id, fields)->
				space = Session.get("spaceId")
				Meteor.call("archive_transfer",record_id,space,
					(error,result) ->
						if !result[0]
							swal("请先添加档案至此移交单")
							return
						else
							text = "共移交"+result[0]+"条,"+"成功"+result[1]+"条"
							swal(text)
						if result[0] == result[1]
							Creator.Collections["archive_transfer"].update({_id:record_id},{$set:{transfer_state:"已移交",transfer_time:new Date(),transfered_by:Meteor.userId()}})	
					)
		submit:
			label:"发起审批"
			visible:true
			on:"record"
			todo:(object_name, record_id, fields)->
				Meteor.call('submit_borrow',record_id,
					(error,result)->
						if !error
							swal("提交成功，等待审核")
						else
							swal("提交失败，请再次提交")
					)
