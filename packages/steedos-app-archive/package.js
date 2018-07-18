Package.describe({
	name: 'steedos:app-archive',
	version: '0.0.5',
	summary: 'Creator archive',
	git: ''
});

Package.onUse(function(api) {
	api.use('steedos:creator@0.0.5');
	api.use('coffeescript@1.11.1_4');

	api.use('steedos:logger@0.0.2');

	api.addFiles('core.coffee');	
	api.addFiles('client/core.coffee','client');



	// 档案管理
	api.addFiles('archive_manage.coffee');
	api.addFiles('models/archive_manage/archive_gongwen.coffee');
	api.addFiles('models/archive_manage/archive_keji.coffee');
	api.addFiles('models/archive_manage/archive_kejiditu.coffee');
	api.addFiles('models/archive_manage/archive_wenshu.coffee');
	api.addFiles('models/archive_manage/archive_kuaiji.coffee');
	api.addFiles('models/archive_manage/archive_kejiditu.coffee');
	api.addFiles('models/archive_manage/archive_rongyu.coffee');
	api.addFiles('models/archive_manage/archive_shengxiang.coffee');
	api.addFiles('models/archive_manage/archive_dianzi.coffee');
	api.addFiles('models/archive_manage/archive_tongji.coffee');
	api.addFiles('models/archive_manage/archive_shenji.coffee');
	
	// 档案借阅
	api.addFiles('archive_borrow.coffee');
	api.addFiles('models/archive_borrow/archive_borrow.coffee');

	// 档案借阅
	api.addFiles('archive_borrow.coffee');
	api.addFiles('models/archive_borrow/archive_borrow.coffee');

	// 档案销毁
	api.addFiles('archive_destroy.coffee');
	api.addFiles('models/archive_destroy/archive_destroy.coffee');

	// 档案移交
	api.addFiles('archive_transfer.coffee');
	api.addFiles('models/archive_transfer/archive_transfer.coffee');

	// 档案统计
	api.addFiles('archive_statistics.coffee');

	// 档案维护
	api.addFiles('archive_setting.coffee');
	api.addFiles('models/archive_setting/archive_fonds.coffee');
	api.addFiles('models/archive_setting/archive_organization.coffee');
	api.addFiles('models/archive_setting/archive_retention.coffee');
	api.addFiles('models/archive_setting/archive_classification.coffee');

	api.addFiles('models/archive_setting/archive_audit.coffee');
	api.addFiles('models/archive_setting/archive_entity_relation.coffee');
	
	// 方法
	api.addFiles('server/methods/archive_borrow.coffee', 'server');
	api.addFiles('server/methods/archive_destroy.coffee', 'server');
	api.addFiles('server/methods/archive_export.coffee', 'server');
	api.addFiles('server/methods/archive_new_audit.coffee', 'server');
	api.addFiles('server/methods/archive_receive.coffee', 'server');
	api.addFiles('server/methods/archive_transfer.coffee', 'server');
})