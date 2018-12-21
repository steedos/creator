Creator.Menus.push( 
    # 单位管理员可以创建和设置流程及相关参数。
    { _id: 'menu_workflow', name: '审批', permission_sets: ["admin", "workflow_admin"], sort: 40, expanded: false },
    { _id: 'flows', name: '流程', permission_sets: ["admin", "workflow_admin"], object_name: "flows", parent: 'menu_workflow', sort: 10 },
    { _id: 'flow_roles', name: '审批岗位', permission_sets: ["admin", "workflow_admin"], object_name: "flow_roles", parent: 'menu_workflow', sort: 20 },
    { _id: 'flow_positions', name: '岗位成员', permission_sets: ["admin", "workflow_admin"], object_name: "flow_positions", parent: 'menu_workflow', sort: 30 },
    { _id: 'categories', name: '流程分类', permission_sets: ["admin", "workflow_admin"], object_name: "categories", parent: 'menu_workflow', sort: 40 },
    { _id: 'instance_number_rules', name: '流程编号规则', permission_sets: ["admin", "workflow_admin"], object_name: "instance_number_rules", parent: 'menu_workflow', sort: 50 },
    { _id: 'space_user_signs', name: '图片签名', permission_sets: ["admin", "workflow_admin"], object_name: "space_user_signs", parent: 'menu_workflow', sort: 60 },
    { _id: 'instances_statistic', name: '效率统计', permission_sets: ["admin", "workflow_admin"], object_name: "instances_statistic", parent: 'menu_workflow', sort: 70 },
    { _id: 'tableau_info', name: 'Tableau', permission_sets: ["admin", "workflow_admin"], template_name: "tableau_info", parent: 'menu_workflow', sort: 80 },
);