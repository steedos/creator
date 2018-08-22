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

# 更新文件状态
Creator.syncFileState = (file_ids)->
    if Steedos.isCloudAdmin()
        Meteor.call("start_syncFileState",file_ids
            (error,result) ->
                if result
                    console.log result
                else
                    console.log error
        )
        return
    else
        return 'You are not CloudAdmin!'
