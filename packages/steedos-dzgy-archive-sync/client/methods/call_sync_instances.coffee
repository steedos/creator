Creator.syncInstances = (spaces, need_recorded_flows, ins_ids)->
    if Steedos.isCloudAdmin()
        if !spaces
            return 'no spaces!'
        if !need_recorded_flows
            return 'no need recorded flows!'
        Meteor.call("syncInstances",spaces, need_recorded_flows, ins_ids
            (error,result) ->
                console.log 'Success!'
        )
        return
    else
        return 'You are not CloudAdmin!'