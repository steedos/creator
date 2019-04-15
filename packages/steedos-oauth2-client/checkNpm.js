// fix warning: xxx not installed

import { checkNpmVersions } from 'meteor/tmeasday:check-npm-versions';
checkNpmVersions({
    "passport": "^0.4.0",
    "passport-oauth": "^1.0.0"
}, 'steedos:oauth2-client');
