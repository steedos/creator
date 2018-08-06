Creator.startSyncAttachs = (sDate, fDate)->
# ---------------------------------------------------
    if Steedos.isCloudAdmin()
        spaceId = Steedos.spaceId()
        spaces = []
        # ins_ids = []
        spaces.push spaceId

        flows = Meteor.settings?.records_qhd?.settings_records_qhd?.to_archive?.contract_instances?.flows
        
        Meteor.call("start_instanceToArchive", spaces, flows, sDate, fDate
            (error,result) ->
                console.log 'Success'
        )
        return
    else
        return 'You are not CloudAdmin!'
