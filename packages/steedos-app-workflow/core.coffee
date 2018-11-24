@Workflow = {}
Workflow.openFlowDesign = (locale, space, flow, companyId)->
	url = "/packages/steedos_admin/assets/designer/index.html?locale=#{locale}&space=#{space}"
	if flow
		url = url + "&flow=#{flow}"
	if companyId
		url = url + "&companyId=#{companyId}"
	Steedos.openWindow Steedos.absoluteUrl(url)
