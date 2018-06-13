Package.describe({
	name: 'steedos:records-xml',
	version: '0.0.1',
	summary: 'Steedos xml',
	git: ''
});

Npm.depends({
	'request'  : '2.81.0',
	'node-schedule' : '1.2.1',
	cookies: "0.6.1",
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

	api.addFiles('server/lib/records_xml.coffee', 'server');

	api.addFiles('server/lib/export_to_xml.coffee', 'server');

	api.export('RecordsXML');

	api.export('Export2XML');

});

Package.onTest(function (api) {

});