Meteor.methods
    'object_workflows.get': (space) ->
        check space, String

        if not this.userId
            throw new Meteor.Error 'not-authorized'

        ows = Creator.getCollection('object_workflows').find({ space: space }, { fields: { object_name: 1, flow_id: 1, space: 1 } }).fetch()
        _.each ows,(o) ->
            o.flow_name = Creator.getCollection('flows').findOne(o.flow_id, { fields: { name: 1 } })?.name

        return ows