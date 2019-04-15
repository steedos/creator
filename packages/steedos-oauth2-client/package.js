Package.describe({
	name: 'steedos:oauth2-client',
	version: '0.0.1',
	summary: '',
	git: '',
	documentation: null
});

Package.onUse(function(api) {
	api.versionsFrom("1.2.1");

	api.use('coffeescript');
	api.use('check');
	api.use('underscore');
	api.use('ecmascript');
	api.use('accounts-password@1.1.4');
	api.use('simple:json-routes@2.1.0');
	api.use('ddp-common');
	api.use(['webapp'], 'server');


	api.addFiles('checkNpm.js', 'server');


	api.addFiles('server/router.coffee', 'server');

});

Package.onTest(function(api) {

});
