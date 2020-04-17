import './header_profile.html';
import HeaderProfileContainer from './containers/HeaderProfile.jsx'

Template.headerProfile.helpers({
	component: function(){
		return HeaderProfileContainer
	},
	avatarURL: function(){
		var userId = Meteor.userId();
		var user = Creator.getCollection("users").findOne({_id: userId});
		var avatar = null;
		if(user){
			avatar = user.avatar;
		}
		if(avatar){
			return Steedos.absoluteUrl(`avatar/${Meteor.userId()}?w=220&h=200&fs=160&avatar=${avatar}`);
		}else{
			return Creator.getRelativeUrl("/packages/steedos_lightning-design-system/client/images/themes/oneSalesforce/lightning_lite_profile_avatar_96.png");
		}
	},
	logoutAccountClick: function(){
		return function(){
			FlowRouter.go("/steedos/logout");
		}
	},
	settingsAccountClick: function(){
		return function(){
			var url = Steedos.getUserRouter();
			FlowRouter.go(url);
		}
	}
});