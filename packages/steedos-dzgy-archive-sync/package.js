Package.describe({
	name: 'steedos:dzgy-archive-sync',
	version: '0.0.1',
	summary: 'Steedos libraries',
	git: ''
});

Npm.depends({
	'request'  : '2.81.0',
	'node-schedule' : '1.2.1',
	cookies: "0.6.1",
	mkdirp: "0.3.5",
	"eval": "0.1.2",
});

Package.onUse(function (api) {
	api.versionsFrom('1.0');
	api.use('reactive-var');
	api.use('reactive-dict');
	api.use('coffeescript');
	api.use('ddp');
	api.use('check');
	api.use('underscore');

	api.use('steedos:logger');

	api.use('steedos:creator');
	api.use('steedos:objects');

	api.use('steedos:app-workflow');
	api.use('steedos:app-archive');

	api.addFiles('server/lib/instance_manager.coffee', 'server');

	api.addFiles('server/lib/instances_to_archive.coffee', 'server');

	api.addFiles('server/lib/records_sync.coffee', 'server');

	api.export('steedosRequest');

	api.export('InstancesToArchive');

	api.export("InstanceManager");

	api.export('RecordsSync');

});

Package.onTest(function (api) {

});