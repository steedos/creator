Creator.Objects.vip_address =
	name: "vip_address"
	label: "收货地址"
	icon: "opportunity"
	fields:
		name:
            label:'收货人'
            type:'text'
        address:
            label:'地址'
            type:'location'
        door:
            label:'门牌号'
            type:'text'
        gender:
            label:'性别'
            type:'select'
            options:["男","女"]
        phone:
            label:'手机号'
            type:'text'
        is_default:
            type:'boolean'
            label:'默认地址'