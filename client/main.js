require("./theme.less");

import("./main.html");

Template.preloadAssets.helpers({
    absoluteUrl(url){
        return Steedos.absoluteUrl(url)
    }
});

Meteor.startup(function(){
    if (Steedos.isMobile() && Meteor.settings.public && Meteor.settings.public.mobile && Meteor.settings.public.mobile.enabled == false) {
        $('head meta[name=viewport]').remove();
        $('head').append('<meta name="viewport" content="">');
    }
});