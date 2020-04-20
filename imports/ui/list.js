import './list.html';
import ListContainer from './containers/ListContainer.jsx'
import { store, loadGridEntitiesData } from '@steedos/react';

let isListRendered = false;

const getListProps = (withoutFilters) => {
	let object = Creator.getObject();
	let listview = Creator.getListView();
	let columns = listview.columns.map((item) => {
		let fieldName = typeof item === "string" ? item : item.field;
		let field = object.fields[fieldName];
		if (field) {
			return {
				field: fieldName,
				label: field.label,
				type: field.type,
				is_wide: field.is_wide
			}
		}
		else {
			console.error(`The object ${object.name} don't exist field '${fieldName}'`);
		}
	});
	debugger;
	let filters = [];
	// let filters = [['name', 'contains', '书'], ['contract_state', '<>', 'terminated']];
	// filters = Creator.getListViewFilters(object_name, list_view_id, is_related, related_object_name, record_id);
	if (!withoutFilters) {
		// filters = Tracker.nonreactive(() => {
		// 	return Creator.getListViewFilters(object.name, listview._id);
		// });
		// 这里不可以用Tracker.nonreactive，因为当有过滤条件时，滚动翻页及滚动刷新需要传入这里的过滤条件
		filters = Creator.getListViewFilters(object.name, listview._id);
	}
	columns = _.without(columns, undefined, null);
	console.log("====getListProps==filters=", filters);
	// console.log("====getListProps==filters===stringify===", JSON.stringify(filters));
	// console.log("====getListProps==columns=", columns);
	return {
		objectName: object.name,
		columns: columns,
		filters: filters,
		// filters: [[[[[["name","contains","%E4%B9%B0%E5%8D%96"]]],"and",[["contract_state","<>","terminated"]]]]],
		pageSize: 5,
		pager: true,
		initializing: 1
	}
}

Template.list.helpers({
	component: function () {
		return ListContainer;
	},
	listProps: function () {
		console.log("===Template.list.helpers=listProps======")
		return getListProps();
	}
})

Template.list.onCreated(function () {
	// 切换对象或视图时，会再进一次onCreated，所以object、listview、options不需要放到autorun中
	console.log("Template.list.onCreated===");
	let object = Creator.getObject();
	let listview = Creator.getListView();
	let options = getListProps(true);
	console.log("Template.list.onCreated==listview=", listview.label);
	Meteor.defer(()=>{
		this.autorun((c) => {
			// TODO:部分对象切换视图时会进两次该函数，比如合同对象，估计是getListViewFilters监听了什么额外变量
			console.log("Template.list.onCreated=====autorun==outside==", isListRendered);
			console.log("Template.list.onCreated=====autorun==bootstrapLoaded==", Creator.bootstrapLoaded.get());
			let filters = Creator.getListViewFilters(object.name, listview._id);
			if(isListRendered){
				options.filters = filters;
				let newOptions = {
					id: "steedos-list",
					initializing: 1
				};
				if (options.pager) {
					newOptions.count = true;
				}
				store.dispatch(loadGridEntitiesData(Object.assign({}, options, newOptions)))
				// store.dispatch(loadNotificationsData({id: "steedos-header-notifications"}))
				console.log("Template.list.onCreated=====autorun====", filters);
			}
			isListRendered = true;
		});
	});
})

Template.list.onDestroyed(function () {
	console.log("Template.list.onDestroyed===xx====");
	isListRendered = false;
})

