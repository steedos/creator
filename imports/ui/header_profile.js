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
	},
	footers: function(){
		let links = Meteor.settings.public && Meteor.settings.public.links;
		let helpUrl = "https://www.steedos.com/help";
		let downloadUrl = "https://www.steedos.com/help/download";
		if(links && links.help){
			helpUrl = links.help;
		}
		if(links && links.download){
			downloadUrl = links.download;
		}
		return [
			{label: "帮助文档", onClick: function(){return Steedos.openWindow(helpUrl)}},
			{label: "下载客户端", onClick: function(){return Steedos.openWindow(downloadUrl)}},
			{label: "关于", onClick: function(){return FlowRouter.go("/app/admin/page/creator_about");}}
		]
	}
});