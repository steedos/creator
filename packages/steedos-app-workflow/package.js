Package.describe({
	name: 'steedos:app-workflow',
	version: '0.0.1',
	summary: 'Creator workflow',
	git: '',
	documentation: null
});

Npm.depends({
	mkdirp: "0.3.5"
});

Package.onUse(function(api) {
	api.use('kadira:flow-router@2.10.1');
	api.use('underscore@1.0.10');
	api.use('steedos:creator@0.0.5');
	api.use('coffeescript@1.11.1_4');

	api.use('steedos:cfs-standard-packages@0.5.10');
	api.use('steedos:cfs-s3@0.1.4');
	api.use('steedos:cfs-aliyun@0.1.0');

	api.addFiles('workflow.app.coffee');
	api.addFiles('models/Instances.coffee');
	api.addFiles('models/forms.coffee');
	api.addFiles('models/flows.coffee');
	api.addFiles('models/statistic_instance.coffee');
	api.addFiles('models/categories.coffee');

	api.addFiles('client/instance_view.css', 'client');

	api.addFiles('client/core.coffee', 'client');
	api.addFiles('client/router.coffee', 'client');

	// api.addFiles('cfs/instances.coffee', 'server');
})