Creator.callSyncInstances = (need_recorded_flows,ins_ids)->
    if Steedos.isCloudAdmin()
        if need_recorded_flows and Object.prototype.toString.call(need_recorded_flows) == "[object Array]"
            spaceId = Steedos.spaceId()
            spaces = []
            spaces.push spaceId
            Meteor.call("syncArchives",spaces, need_recorded_flows, ins_ids
                (error,result) ->
                    console.log 'Success!'
            )
            return
        else
            return 'need_recorded_flows shoule be array!'
    else
        return 'You are not CloudAdmin!'