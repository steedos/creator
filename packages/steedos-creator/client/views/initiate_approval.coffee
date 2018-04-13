Template.initiate_approval.helpers
    flows: () ->
        return _.where Creator.object_workflows, { object_name: Session.get('object_name') }

Template.initiate_approval.events
