Creator.startSyncAttachs = (sDate, fDate)->
# ---------------------------------------------------
    if Steedos.isCloudAdmin()
        
        Meteor.call("start_instanceToArchive", sDate, fDate
            (error,result) ->
                console.log 'Success'
        )
        return
    else
        return 'You are not CloudAdmin!'
