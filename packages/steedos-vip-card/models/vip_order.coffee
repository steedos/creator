Creator.Objects.vip_order =
	name: "vip_order"
	label: "订单"
	icon: "apps"
	fields:
		name:
			label: "名称"
			type: "text"
			required: true

		owner:
			label: '顾客'
			type: 'lookup'
			required: true
			reference_to:'users'

		amount:
			label: '应付金额'
			type: 'number'
			scale: 2
			defaultValue: 0
			required: true

		amount_paid:
			label: '已付金额'
			type: 'number'
			scale: 2
			defaultValue: 0

		description:
			label: '描述'
			type: 'textarea'

		status: # draft, pending, completed, canceled
			label: '状态'
			type: 'text'
			required: true

		store:
			label:'门店'
			type:'lookup'
			reference_to:'vip_store'
			required: true

		card:
			label:'会员卡'
			type:'master_detail'
			reference_to:'vip_card'
			required: true

		type: # recharge, pay, ...
			label: '类型'
			type: 'text'
			required: true

	permission_set:
		user:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: false
		admin:
			allowCreate: true
			allowDelete: true
			allowEdit: true
			allowRead: true
			modifyAllRecords: true
			viewAllRecords: true

	list_views:
		all:
			label: "所有订单"
			columns: ["name","owner", "amount_paid","description"]
			filter_scope: "space"
		pending:
			label:"未完成订单"
			columns:["name","owner", "amount","amount_paid","description"]
			filter_scope: "space"
			filters: [["status", "=", "pending"]]                
	triggers:
		"after.update.server.vip_order":
			on: "server"
			when: "after.update"
			todo: (userId, doc, fieldNames, modifier, options)->
				if modifier.$set?.status is 'completed' and this.previous.status isnt 'completed'
					if doc.type is 'recharge'
						console.log 'recharge'
						amount = doc.amount
						cardId = doc.card
						if doc.is_actived
							Creator.getCollection('vip_card').update({ _id: cardId }, { $inc: { balance: amount } })
						else
							Creator.getCollection('vip_card').update({ _id: cardId }, { $inc: { balance: amount }, $set: { is_actived: true } })
						newestCard = Creator.getCollection('vip_card').findOne(cardId, { fields: { balance: 1 } })
						Creator.getCollection('vip_billing').insert({
							amount: amount
							store: doc.store
							card: cardId
							description: doc.name
							owner: doc.owner
							space: doc.space
							balance: newestCard.balance
						})
					else if doc.type is 'pay'
						console.log 'pay'
						point = parseInt(doc.amount)
						if point > 0
							Creator.getCollection('vip_card').update({ _id: doc.card }, { $inc: { points: point } })