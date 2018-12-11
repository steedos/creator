Package.describe({
	name: 'steedos:devexpress',
	version: '0.0.1',
	summary: 'Devexpress for Steedos Creator',
	git: '',
	documentation: null
});

Package.onUse(function (api) {
	api.addAssets([
		'client/css/icons/dxicons.ttf',
		'client/css/icons/dxicons.woff',
		'client/css/icons/dxicons.woff2',
		'client/css/icons/dxiconsios.ttf',
		'client/css/icons/dxiconsios.woff',
		'client/css/icons/dxiconsios.woff2',
		'client/css/icons/dxiconsmaterial.ttf',
		'client/css/icons/dxiconsmaterial.woff',
		'client/css/icons/dxiconsmaterial.woff2'
	], 'client');

	api.addFiles('client/jszip/jszip.js', 'client');
	api.addFiles('client/css/dx.spa.css', 'client');
	api.addFiles('client/css/dx.common.css', 'client');
	api.addFiles('client/css/dx.material.light.blue.css', 'client');
	api.addFiles('client/css/dx.material.light.blue.fix.css', 'client');
	api.addFiles('client/js/dx.all.debug.js', 'client');
	api.addFiles('client/js/dx.messages.zh.js', 'client');
	api.addFiles('client/js/dx.date.formatter.js', 'client');
	api.addFiles('client/js/dx.date.locale.js', 'client');
})