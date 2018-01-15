Meteor.publish "object_listviews", (object_name)->
    return Creator.Collections.object_listviews.find(object_name: object_name)