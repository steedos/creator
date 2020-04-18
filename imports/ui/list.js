import './list.html';
import ListContainer from './containers/ListContainer.jsx'

const getListProps = ()=>{
	let object = Creator.getObject();
	let listview = Creator.getListView();
	let columns = listview.columns.map((item)=>{
		let fieldName = typeof item === "string" ? item : item.field;
		let field = object.fields[fieldName];
		if(field){
			return {
				field: fieldName,
				label: field.label,
				type: field.type,
				is_wide: field.is_wide
			}
		}
		else{
			console.error(`The object ${object.name} don't exist field '${fieldName}'`);
		}
	});
	debugger;
	let filters = [['name', 'contains', '书'], ['contract_state', '<>', 'terminated']];
	// filters = Creator.getListViewFilters(object_name, list_view_id, is_related, related_object_name, record_id);
	filters = Creator.getListViewFilters(object.name, listview._id);
	columns = _.without(columns,undefined,null);
	console.log("====getListProps==filters=", filters);
	console.log("====getListProps==filters===stringify===", JSON.stringify(filters));
	console.log("====getListProps==columns=", columns);
	return {
		objectName: object.name,
		columns: columns,
		filters: filters,
		// filters: [[[[[["name","contains","%E4%B9%B0%E5%8D%96"]]],"and",[["contract_state","<>","terminated"]]]]],
		pageSize: 5,
		pager: true
	}
}

Template.list.helpers({
	component: function(){
		return ListContainer;
	},
	listProps: function(){
		console.log("===Template.list.helpers=listProps======")
		return getListProps();
	}
})

