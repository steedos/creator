Creator.Objects.archive_borrow = 
	name: "archive_borrow"
	icon: "file"
	label: "借阅"
	enable_search: false
	fields:
		borrow_name:
			type:"text"
			label:"标题"
			sortable:true
			is_name:true
			#defaultValue:当前年度的借阅单总数+1
		file_type:
			type:"text"
			label:"类别"
			defaultValue:"立卷方式(文件级)"
			omit:true
		unit_info:
			type:"text"
			label:"单位"
			defaultValue:()->
				return  Creator.Collections["space_users"].findOne({user:Meteor.userId(),space:Session.get("spaceId")},{fields:{company:1}}).company
			#字段生成，不可修改
		deparment_info:
			type:"text"
			label:"部门"
			required:true
		phone_number:
			type:"text"
			label:"联系方式"
			required:true
		start_date:
			type:"date"
			label:"借阅日期"
			defaultValue:()->
				return new Date()
			sortable:true
		end_date:
			type:"date"
			label:"归还日期"
			sortable:true
			defaultValue:()->
				now = new Date()
				return new Date(now.getTime()+7*24*3600*1000)
		#	defaultValue:new Date() #应该是当前日期加7天
			required:true
		use_with:
			type:"select"
			label:"利用目的"
			defaultValue:"工作查考"
			options:[
				{label: "工作查考", value: "工作查考"},
				{label: "遍史修志", value: "遍史修志"},
				{label: "学术研究", value: "学术研究"},
				{label: "经济建设", value: "经济建设"},
				{label: "宣传教育", value: "宣传教育"},
				{label: "其他", value: "其他"},
			]
			sortable:true
		use_fashion:
			type:"select"
			label:"利用方式"
			defaultValue:"实体借阅"
			options:[
				{label: "实体借阅", value: "实体借阅"},
				{label: "实体外借", value: "实体外借"},
			]
			sortable:true
		approve:
			type:"textarea"
			label:"单位审批"
			is_wide:true
			readonly:true
		description:
			type:"textarea"
			label:"备注"
			is_wide:true
		status:
			type:"select"
			label:"状态"
			options: [
				{label: "未审批", value: "未审批"},
				{label: "已审批", value: "已审批"},
				{label: "续借审批中", value: "续借审批中"},
				{label: "续借已审批", value: "续借已审批"},
				{label: "已移交审批", value: "已移交审批"},
				{label: "移交审批完成", value: "移交审批完成"},
				{label: "已结单", value: "已结单"}
				]
			defaultValue:"未审批"
			sortable:true
			omit:true
		relate_record:
			type:"lookup"
			label:"题名"
			is_wide:true
			reference_to:"archive_records"
		year:
			type:"text"
			label:"年度"
			omit:true
		detail_status:
			type:"select"
			label:"明细状态"
			omit:true
			options:[
				{label:"申请中",value:"申请中"},
				{label:"不予批准",value:"不予批准"},
				{label:"已批准",value:"已批准"},
				{label:"审批中",value:"审批中"},
				{label:"续借审批中",value:"续借审批中"},
				{label:"续借已审批",value:"续借已审批"},
				{label:"已归还",value:"已归还"},
				{label:"逾期",value:"逾期"}
				]
			sortable:true
		is_approved:
			type:"boolean"
			defaultValue:false
			omit:true
		#我的借阅记录是可以被删除的，不过是假删除
		is_deleted:
			type:"boolean"
			defaultValue:false
			omit:true 
	list_views:
		default:
			columns:["borrow_name","created","end_date","created_by","unit_info
			","deparment_info","phone_number","relate_record","year"]
		all:
			label:"所有借阅记录"
		mine:
			label:"我的借阅记录"
			filter_scope: "mine"
			filters: [["is_approved", "$eq", true],["is_deleted", "$eq", false]]
		approving:
			label:"审批中"
			filter_scope: "mine"
			filters: [["is_approved", "$eq", false]]
	triggers:
		"before.insert.server.default": 
			on: "server"
			when: "before.insert"
			todo: (userId, doc)->
				now = new Date()
				doc.created_by = userId;
				doc.created = now
				doc.owner = userId
				doc.is_deleted = false
				doc.is_approved = false
				doc.year = now.getFullYear().toString()
				return true
		"after.insert.server.default": 
			on: "server"
			when: "after.insert"
			todo: (userId, doc)->
				Creator.Collections["archive_records"].direct.update({_id:doc.relate_record},{$set:{is_borrowed:true,borrowed:new Date(),borrowed_by:userId}})
				Meteor.call("archive_new_audit",doc.relate_record,"借阅档案","成功",doc.space)
				return true
		"after.insert.client.default": 
			on: "client"
			when: "after.insert"
			todo: (userId, doc)->
				toastr.success("借阅成功")
	permission_set:
		user:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: false
			modifyAllRecords: false
			viewAllRecords: false 
		admin:
			allowCreate: true
			allowDelete: true
			allowEdit: true
			allowRead: true
			modifyAllRecords: true
			viewAllRecords: true 
	actions: 
		restore:
			label: "归还"
			visible: true
			on: "list"
			todo:()->
				if Creator.TabularSelectedIds?["archive_borrow"].length == 0
					alert("请先选择要归还的借阅单")
					return
				if Session.get("list_view_id") =="mine"
					Creator.TabularSelectedIds?["archive_borrow"].forEach (SelectedId)->
						Creator.Collections["archive_borrow"].update({_id:SelectedId},{$set:{is_deleted:true}},
							(error,result)->
								console.log error
								if !error
									recordId = Creator.Collections["archive_borrow"].findOne({_id:SelectedId}).relate_record
									Creator.Collections["archive_records"].update({_id:recordId},{$set:{is_borrowed:false,modified:new Date(),modified_by:Meteor.userId()}})
									#Creator.Collections["archive_borrow"].update(
									alert("归还成功，欢迎再次借阅")
									Meteor.call("archive_new_audit",recordId,"归还档案","成功",Session.get("spaceId"))
								else
									alert("归还失败，请再次操作")
									Meteor.call("archive_new_audit",recordId,"归还档案","失败",Session.get("spaceId"))
								)
				else
					alert("请在我的借阅视图下执行操作")


		renew:
			label:"续借"
			visible:true
			on: "list"
			todo:()->
				if Creator.TabularSelectedIds?["archive_borrow"].length == 0
					alert("请先选择要续借的借阅单")
					return
				if Session.get("list_view_id") =="mine"
					now = new Date()
					start_date = now
					end_date =new Date(now.getTime()+7*24*3600*1000)
					Creator.TabularSelectedIds?["archive_borrow"].forEach (SelectedId)->
						Creator.Collections["archive_borrow"].update({_id:SelectedId},{$set:{start_date:start_date,end_date:end_date,is_approved:false}},
							(error,result)->
								console.log error
								if !error
									recordId = Creator.Collections["archive_borrow"].findOne({_id:SelectedId}).relate_record
									#Creator.Collections["archive_borrow"].update(
									alert("续借成功")
									Meteor.call("archive_new_audit",recordId,"续借档案","成功",Session.get("spaceId"))
								else
									alert("续借失败")
									Meteor.call("archive_new_audit",recordId,"续借档案","失败",Session.get("spaceId"))
								)
				else
					alert("请在我的借阅视图下执行操作")
		view:
			label:"查看原文"
			visible:true
			on: "record"
			todo:(object_name, record_id, fields)->
				if Session.get("list_view_id") =="mine"
					FlowRouter.go("http://192.168.0.89:5000/app/archive/cms_files/view/bX27DGCYuiWBacerp")
				else
					alert("请在我的借阅视图下执行操作")