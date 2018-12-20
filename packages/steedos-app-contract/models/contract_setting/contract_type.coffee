Creator.Objects.contract_type = 
    name: "contract_type"
    icon: "record"
    label: "合同类型"
    fields:
        number:
            type: "number"
            label: "序号"
        name:
            type: "text"
            label: "合同分类"
         remarks:
            type: "text"
            label: "合同说明"
        created:
            type: "datetime"
            label: "创建时间"
        created_by:
            type: "text"
            label: "创建人"
            hidden: true
        modified:
            type: "datetime"
            label: "修改时间"
        modified_by:
            type: "text"
            label: "修改人"
            hidden: true
        yinhuashuilv:
            type: "number"
            label: "印花税率"
    
    permission_set:
        user:
            allowCreate: true
            allowDelete: true
            allowEdit: true
            allowRead: true
            modifyAllRecords: true
            viewAllRecords: true 
        admin:
            allowCreate: true
            allowDelete: true
            allowEdit: true
            allowRead: true
            modifyAllRecords: true
            viewAllRecords: true	
    
    list_views:
        all:
            label: "全部"
            filter_scope: "space"
            columns:["name","remarks","yinhuashuilv","created","modified"]