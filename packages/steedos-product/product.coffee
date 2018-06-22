Creator.Objects.product =
	name: "product"
	label: "商品"
	icon: "product"
	enable_files:true
	fields:
        name:
            label:'商品'
            type:'text'
            is_wide:true
        default_price:
            label:'默认价格'
            type:'currency'
        compared_price:
            label:'原价'
            type:'currency'
        description:
            label:'备注'
            type:'text'
            is_wide:true
        covers:
            label:'轮播图'
            type:'image'
            multiple:true
        images:
            label:'展示图'
            type:'image'
            multiple:true
        video:
            label:'视频'
            type:'video'
        categories：
            label:'分类'
            type:'text'  
            multiple:true
        tags:
            label:'标签'
            type:'text' 
        vendor:
            label:'供应商'
            type:'text' 
        status:
            label:'状态'
            type:'text'
            #草稿，上架，下架
        weight:
            label:'重量'
            type:'number'   
            scale: 2

        