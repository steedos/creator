Creator.callSyncInstances = (spaces, need_recorded_flows,ins_ids)->
    if Steedos.isSpaceAdmin()
        if !need_recorded_flows
            return 'no need recorded flows!'
        spaces = []
        spaceId = Steedos.spaceId()
        spaces.push spaceId
        if !spaces || spaces==[]
            return 'no spaces!'
        Meteor.call("syncArchives",spaces, need_recorded_flows, ins_ids
            (error,result) ->
                console.log 'Success!'
        )
        return
    else
        return 'You are not CloudAdmin!'