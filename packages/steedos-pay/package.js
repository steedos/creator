Package.describe({
    name: 'steedos:pay',
    version: '0.0.1',
    summary: 'pay',
    git: ''
});

Npm.depends({
    "xml2js": "0.4.17",
    "MD5": "1.2.1",
    "cookies": "0.6.1",
    "request": "2.87.0"
});

Package.onUse(function (api) {

    api.use('ecmascript');
    api.use('coffeescript@1.11.1_4');
    api.use('simple:json-routes@2.1.0');
    api.use('steedos:creator@0.0.4');

    api.addFiles('models/billing_record.coffee');
    api.addFiles('server/lib/util.js');
    api.addFiles('server/lib/wxpay.js');
    api.addFiles('server/lib/pay_manager.coffee');
    api.addFiles('server/routes/api_steedos_weixin_card_recharge.coffee');
    api.addFiles('server/routes/api_steedos_weixin_card_recharge_notify.coffee');

    api.export(['payManager'], ['server']);
})