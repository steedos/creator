import './list.html';
import ListContainer from './containers/ListContainer.jsx'
import { store, loadGridEntitiesData } from '@steedos/react';

let isListRendered = false;
const defaultListId = "steedos-list";

const getListProps = ({id, object_name, related_object_name, is_related, recordsTotal}, withoutFilters) => {
	let object, list_view_id;
	object = Creator.getObject(object_name);
	if (!object) {
		return;
	}
	let record_id = Session.get("record_id");
	if (is_related) {
		list_view_id = Creator.getListView(related_object_name, "all")._id;
	} else {
		list_view_id = Session.get("list_view_id");
	}

	if (!list_view_id) {
		toastr.error(t("creator_list_view_permissions_lost"));
		return;
	}
	let curObjectName;
	curObjectName = is_related ? related_object_name : object_name;
	let curObject = Creator.getObject(curObjectName);
	let listview = Creator.getListView(curObjectName, list_view_id);
	let columns = listview.columns.map((item) => {
		let fieldName = typeof item === "string" ? item : item.field;
		let field = curObject.fields[fieldName];
		if (field) {
			return {
				field: fieldName,
				label: field.label,
				type: field.type,
				is_wide: field.is_wide
			}
		}
		else {
			console.error(`The object ${curObject.name} don't exist field '${fieldName}'`);
		}
	});
	let filters = [];
	if (!withoutFilters) {
		// 这里不可以用Tracker.nonreactive，因为当有过滤条件时，滚动翻页及滚动刷新需要传入这里的过滤条件
		filters = Creator.getListViewFilters(object_name, listview._id, is_related, related_object_name, record_id);
	}
	columns = _.without(columns, undefined, null);
	console.log("====getListProps==filters=", filters);
	let pageSize = is_related ? 5 : 10;
	let pager = is_related ? false : true;
	return {
		id: id ? id : defaultListId,
		objectName: curObjectName,
		columns: columns,
		filters: filters,
		pageSize: pageSize,
		pager: pager,
		initializing: 1,
		showMoreLink: true,
		moreLinkHref: (props)=> {
			return Creator.getRelatedObjectUrl(object_name, "-", record_id, related_object_name)
		}
	}
}

Template.list.helpers({
	component: function () {
		return ListContainer;
	},
	listProps: function () {
		debugger;
		console.log("===Template.list.helpers=listProps======")
		return getListProps(this.options);
	}
});

Template.list.onCreated(function () {
	// 切换对象或视图时，会再进一次onCreated，所以object、listview、options不需要放到autorun中
	let { id, object_name, related_object_name, is_related, recordsTotal } = this.data.options;
	console.log("Template.list.onCreated===", id);
	let curObjectName;
	curObjectName = is_related ? related_object_name : object_name;
	if(is_related){
		if(this.unsubscribe){
			this.unsubscribe();
		}
		this.unsubscribe = store.subscribe(()=>{
			let listState = ReactSteedos.viewStateSelector(store.getState(), id);
			if(listState && !listState.loading){
				recordsTotalValue = Tracker.nonreactive(()=>{return recordsTotal.get()});
				recordsTotalValue[curObjectName] = listState.totalCount;
				recordsTotal.set(recordsTotalValue);
			}
		});
	}
	else{
		// let object = Creator.getObject(object_name);
		let list_view_id = Session.get("list_view_id");
		let listview = Creator.getListView(object_name, list_view_id);
		let props = getListProps(this.data.options, true);
		console.log("Template.list.onCreated==listview=", listview.label);
		Meteor.defer(()=>{
			this.autorun((c) => {
				// TODO:部分对象切换视图时会进两次该函数，比如合同对象，估计是getListViewFilters监听了什么额外变量
				console.log("Template.list.onCreated=====autorun==outside==", isListRendered);
				console.log("Template.list.onCreated=====autorun==bootstrapLoaded==", Creator.bootstrapLoaded.get());
				let filters = Creator.getListViewFilters(object_name, list_view_id);
				if(isListRendered){
					props.filters = filters;
					let newProps = {
						id: id ? id : defaultListId,
						initializing: 1
					};
					if (props.pager) {
						newProps.count = true;
					}
					store.dispatch(loadGridEntitiesData(Object.assign({}, props, newProps)))
					console.log("Template.list.onCreated=====autorun====", filters);
				}
				isListRendered = true;
			});
		});
	}
})

Template.list.onDestroyed(function () {
	console.log("Template.list.onDestroyed===xx====");
	isListRendered = false;
	if(this.unsubscribe){
		this.unsubscribe();
	}
})

