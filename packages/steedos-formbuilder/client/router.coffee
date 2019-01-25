FlowRouter.route '/formbuilder',
	action: (params, queryParams)->
		$("body").addClass("loading")
		BlazeLayout.render Creator.getLayout(),
			main: "formBuilder"