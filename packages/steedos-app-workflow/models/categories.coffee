db.categories = new Meteor.Collection('categories')

db.categories._simpleSchema = new SimpleSchema

Creator.Objects.categories =
	name: "categories"
	icon: "metrics"
	label: "流程分类"
	fields:
		name:
			type: "text"
			label: "名称"

	list_views:
		all:
			label: "所有"
			filter_scope: "space"
			columns: ["name"]

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
	db.categories._simpleSchema.i18n("categories")

db.categories.attachSchema db.categories._simpleSchema

if Meteor.isServer

	db.categories.before.remove (userId, doc) ->
		if db.forms.find({space: doc.space, category: doc._id}).count()>0
			throw new Meteor.Error(400, "categories_in_use")
