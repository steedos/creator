Creator.Menus.push( 
    
    { _id: 'menu_objects', name: '应用', permission_sets: ["admin"], expanded: false },
    { _id: 'apps', name: '应用', permission_sets: ["admin"], object_name: "apps", parent: 'menu_objects' },
    { _id: 'objects', name: '对象', permission_sets: ["admin"], object_name: "objects", parent: 'menu_objects' },
    { _id: 'permission_objects', name: '对象权限', permission_sets: ["admin"], object_name: "permission_objects", parent: 'menu_objects' },

    { _id: 'menu_development', name: '开发', permission_sets: ["admin"], expanded: false },
    { _id: 'application_package', name: '软件包', permission_sets: ["admin"], object_name: "application_package", parent: 'menu_development' },
    { _id: 'permission_shares', name: '共享规则', permission_sets: ["admin"], object_name: "permission_shares", parent: 'menu_objects' },
    { _id: 'object_workflows', name: '对象流程', permission_sets: ["admin"], object_name: "object_workflows", parent: 'menu_objects' },
    { _id: 'queue_import', name: '数据导入', permission_sets: ["admin"], object_name: "queue_import", parent: 'menu_development' },
    { _id: 'OAuth2Clients', name: 'OAuth2 应用', permission_sets: ["admin"], object_name: "OAuth2Clients", parent: 'menu_development' },
    { _id: 'OAuth2AccessTokens', name: 'OAuth2 Token', permission_sets: ["admin"], object_name: "OAuth2AccessTokens", parent: 'menu_development' },
    { _id: 'webhooks', name: 'Webhooks', permission_sets: ["admin"], object_name: "webhooks", parent: 'menu_development' },
);