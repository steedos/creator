Creator.Objects.user_star =
	name: "user_star"
	label: "收藏"
	icon: "apps"
	fields:
        related_to:
			label: "收藏对象"
			type: "text"
    permission_set:
        user:
			allowCreate: true
			allowDelete: true
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: false
		admin:
			allowCreate: true
			allowDelete: true
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: false
		member:
			allowCreate: true
			allowDelete: true
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: false
		guest:
			allowCreate: true
			allowDelete: true
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: false