Meteor.methods
    update_filters: (listview_id, filters, filter_scope)->
        Creator.Collections.object_listviews.update({_id: listview_id}, {$set: {filters: filters, filter_scope: filter_scope}})
