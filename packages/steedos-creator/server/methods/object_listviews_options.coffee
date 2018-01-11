Meteor.methods
    update_filters: (listview_id, filters)->
        console.log listview_id
        console.log filters
        Creator.Collections.object_listviews.update({_id: listview_id}, {$set: {filters: filters}})
