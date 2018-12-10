@Workflow = {}
Workflow.openFlowDesign = (locale, space, flow, companyId)->
	url = "/packages/steedos_admin/assets/designer/index.html?locale=#{locale}&space=#{space}"
	if flow
		url = url + "&flow=#{flow}"
	if companyId
		url = url + "&companyId=#{companyId}"
	Steedos.openWindow Steedos.absoluteUrl(url)


Meteor.startup ->
	$(document).keydown (e) ->
		if e.keyCode == "13" or e.key == "Enter"
			if $(".new-flow-modal").length != 1
				return;
			if e.target.tagName != "TEXTAREA" or $(e.target).closest("div").hasClass("bootstrap-tagsinput")
				if $(".new-flow-modal").length == 1
					$(".new-flow-modal .btn-confirm").click()