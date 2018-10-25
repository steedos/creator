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

	// 公文管理
	api.addFiles('archive_manage.coffee');
	
	api.addFiles('models/archive_manage/archive_document.coffee');

	// 公文维护
	api.addFiles('models/archive_setting/archive_classification.coffee');
	
	// 方法
})