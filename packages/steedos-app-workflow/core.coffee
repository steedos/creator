@Workflow = {}
Workflow.openFlowDesign = (locale, space, flow)->
	Steedos.openWindow Steedos.absoluteUrl("/packages/steedos_admin/assets/designer/index.html?locale=#{locale}&space=#{space}&flow=#{flow}")
