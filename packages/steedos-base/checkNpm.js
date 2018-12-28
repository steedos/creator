import { checkNpmVersions } from 'meteor/tmeasday:check-npm-versions';
checkNpmVersions({
	"node-schedule": "1.1.1",
	cookies: "0.6.1",
	"weixin-pay": "1.1.7",
	"xml2js": "0.4.17",
	mkdirp: "0.3.5"
}, 'steedos:base');
