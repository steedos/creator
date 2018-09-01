# =============================================
# spaceId: 工作区ID
# user_ids Array 用户ID
SyncSpaceUserCompany = (spaceId, user_ids) ->
	@spaceId = spaceId
	@user_ids = user_ids
	return

# 递归
SyncSpaceUserCompany.getUserCompany = (organization_id)->
    console.log "getUserCompany", organization_id
    organization = Creator.Collections["organizations"].findOne({
        '_id': organization_id
    })
    console.log "organization", organization?.name
    if organization?.is_subcompany == true
        return organization
    if organization?.parent
        console.log "organization?.parent"
        SyncSpaceUserCompany.getUserCompany(organization.parent)
    else
        return null

#获取所有用户
SyncSpaceUserCompany::getSpaceUserIds = () ->
    query = {
        space: @spaceId
    }
    if @user_ids?.length > 0
        query.user = { $in: @user_ids }
    list = Creator.Collections["space_users"].find(
        query, 
        {
            fields: {
            _id: 1,
            organization: 1
            }
        }).fetch()
    return list


SyncSpaceUserCompany::DoSync = () ->
    console.log "---------"
    space_user_ids = @getSpaceUserIds()
    that = @
    if space_user_ids?.length > 0
        space_user_ids.forEach (space_user)->
            company = SyncSpaceUserCompany.getUserCompany(space_user?.organization)
            console.log "company",company?.name
            if company
                company_id = company?._id
                Creator.Collections["space_users"].direct.update(
                    {_id: space_user._id},
                    {
                        $set: {
                            company: company_id
                        }
                    })