Package.describe({
	name: 'steedos:weixin',
	version: '0.0.1',
	summary: 'Steedos weixin Decryption data',
	git: ''
});

Npm.depends({
	'request': '2.81.0',
	'base-64':'0.1.0'
});


Package.onUse(function(api) {
	api.versionsFrom("1.2.1");
	api.use('simple:json-routes@2.1.0');
	api.use('coffeescript@1.11.1_4');

	api.use('steedos:objects');
	api.use('steedos:weixin-aes');

	api.use(['webapp'], 'server');

	api.addFiles('lib/wx_mini.coffee', 'server');
	api.addFiles('server/routes/mini-sso.coffee', 'server');
	// api.addFiles('server/routes/login.coffee', 'server');
	api.addFiles('server/routes/getPhoneNumber.coffee', 'server');
	api.addFiles('server/routes/card/activate.coffee', 'server');
	api.addFiles('server/routes/card/card_init.coffee', 'server');
	api.addFiles('server/routes/card/getUserCards.coffee', 'server');
	api.addFiles('server/routes/card/space_register.coffee', 'server');
	api.addFiles('server/routes/store/qr_code.coffee', 'server');
	api.addFiles('server/routes/update_user.coffee', 'server');
});

Package.onTest(function(api) {

});
