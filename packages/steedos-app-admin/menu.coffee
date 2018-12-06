
# Menu 支持两种类型的参数
# - template_name 指向 Meteor Template, url=/app/admin/_template/{template_name}/
# - object_name 指向对象, url=/app/admin/{object_name}/grid/all/
Creator.Menus =  [

    { _id: 'account', name: '我的账户', expanded: true },
    { _id: 'account_password', name: '密码', template_name: "account_password", parent: 'account' },
    { _id: 'account_background', name: '背景图', template_name: "account_background", parent: 'account' }

    { _id: 'menu_users', name: '用户管理', expanded: false },
    { _id: 'organizations', name: '部门', object_name: "organizations", parent: 'menu_users' },
    { _id: 'space_users', name: '用户', object_name: "space_users", parent: 'menu_users' },
    { _id: 'permission_set', name: '权限组', object_name: "permission_set", parent: 'menu_users' },

    { _id: 'menu_workflow', name: '流程管理', expanded: false },
    { _id: 'flows', name: '流程', object_name: "flows", parent: 'menu_workflow' },
    { _id: 'flow_roles', name: '审批岗位', object_name: "flow_roles", parent: 'menu_workflow' },
    { _id: 'flow_positions', name: '岗位成员', object_name: "flow_positions", parent: 'menu_workflow' },
    { _id: 'space_user_signs', name: '图片签名', object_name: "space_user_signs", parent: 'menu_workflow' },
    { _id: 'instances_statistic', name: '效率统计', object_name: "instances_statistic", parent: 'menu_workflow' },

    { _id: 'menu_objects', name: '应用与对象', expanded: false },
    { _id: 'apps', name: '应用', object_name: "apps", parent: 'menu_objects' },
    { _id: 'objects', name: '对象', object_name: "objects", parent: 'menu_objects' },

    { _id: 'menu_development', name: '开发', expanded: false },
    { _id: 'application_package', name: '软件包', object_name: "application_package", parent: 'menu_development' },
    { _id: 'queue_import', name: '数据导入', object_name: "queue_import", parent: 'menu_development' },
    { _id: 'permission_shares', name: '共享规则', object_name: "permission_shares", parent: 'menu_development' },
    { _id: 'OAuth2Clients', name: 'OAuth2 应用', object_name: "OAuth2Clients", parent: 'menu_development' },
    { _id: 'OAuth2AccessTokens', name: 'OAuth2 Token', object_name: "OAuth2AccessTokens", parent: 'menu_development' },

];