Creator.Objects.vip_order =
	name: "vip_order"
	label: "订单"
	icon: "order"
	fields:
        name:
            label: "名称"
            type: "text"
        owner:
            label: '顾客'
            type: 'selectuser'
        amount:
            label: '应付金额'
            type: 'number'
            scale: 2
            defaultValue: 0
        amount_paid:
            label: '已付金额'
            type: 'number'
            scale: 2
            defaultValue: 0
        description:
            label: '描述'
            type: 'text'
        status: # draft, pending, completed, canceled
            label: '状态'
            type: 'text'

        store:
            label:'门店'
            type:'lookup'
            reference_to:'vip_store'

        card:
            label:'会员卡'
            type:'master_detail'
            reference_to:'vip_card'

        type: # recharge, pay, ...
            label: '类型'
            type: 'text'
