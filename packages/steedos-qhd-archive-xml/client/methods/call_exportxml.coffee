Creator.startExportXml = (record_ids)->
# ---------------------------------------------------
    if Steedos.isCloudAdmin()
        spaceId = Steedos.spaceId()
        spaces = []
        spaces.push spaceId
        Meteor.call("start_exportxml", spaces, record_ids, 
            (error,result) ->
                console.log 'Success'
        )
        return
    else
        return 'You are not CloudAdmin!'