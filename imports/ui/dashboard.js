import './dashboard.html';
import DashboardContainer from './containers/DashboardContainer.jsx'

Template.dashboard.helpers({
	Dashboard: function(){
		return DashboardContainer
	},
	config: function(){
		var dashboard = Creator.getAppDashboard()
		return dashboard ? dashboard : {}
	}
});

