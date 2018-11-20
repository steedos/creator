db.space_user_signs = new Meteor.Collection('space_user_signs')

db.space_user_signs._simpleSchema = new SimpleSchema

Creator.Objects.space_user_signs =
	name: "space_user_signs"
	icon: "metrics"
	label: "图片签名"
	fields:
		user:
			type: "lookup"
			label: "用户"
			reference_to: "users"
			required: true
			is_name: true

		sign:
			type: "avatar"
			label: "签名"

		company_id:
			label: "所属公司"
			type: "lookup"
			reference_to: "organizations"
			sortable: true
			index: true
			omit: true
			hidden: true

	list_views:
		all:
			filter_scope: "space"
			columns: ["user", "sign"]
			label: "所有"

	permission_set:
		user:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true
		admin:
			allowCreate: true
			allowDelete: true
			allowEdit: true
			allowRead: true
			modifyAllRecords: true
			viewAllRecords: true

if Meteor.isClient
	db.space_user_signs._simpleSchema.i18n("space_user_signs")

db.space_user_signs.attachSchema db.space_user_signs._simpleSchema

if Meteor.isServer

	db.space_user_signs.before.insert (userId, doc) ->
		if not userId
			return

		doc.created_by = userId
		doc.created = new Date()
		doc.modified_by = userId
		doc.modified = new Date()

		su = db.space_users.findOne({space: doc.space, user: userId}, {fields: {company_id: 1}})
		if su && su.company_id
			doc.company_id = su.company_id

