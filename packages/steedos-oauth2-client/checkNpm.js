// fix warning: xxx not installed

import { checkNpmVersions } from 'meteor/tmeasday:check-npm-versions';
checkNpmVersions({
    "passport": "^0.4.0",
    "passport-oauth2": "^1.5.0",
    "mattermost-redux": "^5.9.0",
    "node-fetch": "^2.3.0"
}, 'steedos:oauth2-client');
