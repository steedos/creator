Package.describe({
	name: 'steedos:qhd-archive2xml',
	version: '0.0.1',
	summary: 'Steedos Archive XML File',
	git: ''
});

Npm.depends({
	"xml2js": "0.4.19",
	mkdirp: "0.3.5"
});

Package.onUse(function(api) { 
	api.versionsFrom('METEOR@1.3');

	api.use('coffeescript@1.11.1_4');
	api.use('steedos:base@0.0.71');
	api.use('cfs:standard-packages@0.5.9');
	api.use('cfs:s3@0.1.3');
	api.use('iyyang:cfs-aliyun@0.1.0');

	api.use('steedos:creator');

	api.addFiles('lib/archive2XML.coffee', 'server');

	api.addFiles('lib/createXML.coffee', 'server');

	api.export('Archive2XML');
});