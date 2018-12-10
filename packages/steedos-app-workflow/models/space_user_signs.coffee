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
			filter_by_company: true

		sign:
			type: "avatar"
			label: "签名"

		company_id:
			label: "所属单位"
			type: "lookup"
			reference_to: "organizations"
			sortable: true
			index: true
			omit: true

	list_views:
		all:
			filter_scope: "space"
			columns: ["user", "sign", "company_id"]
			label: "所有"

		company:
			filter_scope: "company"
			columns: ["user", "sign", "company_id"]
			label: "本单位"

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
		workflow_admin:
			allowCreate: true
			allowDelete: false
			allowEdit: true
			allowRead: true
			modifyAllRecords: true
			viewAllRecords: true
			disabled_list_views: ['all']
			disabled_actions: []
			unreadable_fields: []
			uneditable_fields: []
			unrelated_objects: []

if Meteor.isClient
	db.space_user_signs._simpleSchema.i18n("space_user_signs")

db.space_user_signs.attachSchema db.space_user_signs._simpleSchema

if Meteor.isServer

	db.space_user_signs.allow
		insert: (userId, doc) ->
			if (!Steedos.isSpaceAdmin(doc.space, userId))
				return false
			else
				return true

		update: (userId, doc) ->
			if (!Steedos.isSpaceAdmin(doc.space, userId))
				return false
			else
				return true

		remove: (userId, doc) ->
			if (!Steedos.isSpaceAdmin(doc.space, userId))
				return false
			else
				return true

	db.space_user_signs.before.insert (userId, doc) ->
		if not userId
			return

		if (!Steedos.isLegalVersion(doc.space,"workflow.professional"))
			throw new Meteor.Error(400, "space_paid_info_title");

		doc.created_by = userId
		doc.created = new Date()
		doc.modified_by = userId
		doc.modified = new Date()

		userSign = db.space_user_signs.findOne({space: doc.space, user: doc.user});

		if userSign
			throw new Meteor.Error(400, "spaceUserSigns_error_user_sign_exists");

		su = db.space_users.findOne({space: doc.space, user: userId}, {fields: {company_id: 1}})
		if su && su.company_id
			doc.company_id = su.company_id

	db.space_user_signs.before.update (userId, doc, fieldNames, modifier, options) ->

		modifier.$set.modified_by = userId;
		modifier.$set.modified = new Date();
		if (!Steedos.isLegalVersion(doc.space,"workflow.professional"))
			throw new Meteor.Error(400, "space_paid_info_title");
		if modifier.$set.user
			userSign = db.space_user_signs.findOne({space: doc.space, user: modifier.$set.user, _id:{$ne: doc._id}});

			if userSign
				throw new Meteor.Error(400, "spaceUserSigns_error_user_sign_exists");

