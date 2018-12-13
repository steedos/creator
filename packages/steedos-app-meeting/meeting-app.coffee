Creator.Apps.meeting = 
	url: "/app/meeting"
	name: "会议"
	description: "预约会议室，查看一周会议安排表"
	icon: "ion-ios-people-outline" 
	icon_slds: "document" 
	visible:true 
	is_creator:true
	objects: [
		"meeting", "tasks", "notes"
		]


Creator.Menus.push( 
    # 单位管理员可以创建和设置流程及相关参数。
    { _id: 'menu_meeting', name: '会议', permission_sets: ["admin"], expanded: false },
    { _id: 'meetingroom', name: '会议室', permission_sets: ["admin"], object_name: "meetingroom", parent: 'menu_meeting' },
);