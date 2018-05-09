console.log("init app.workflow.view...")
FlowRouter.route "/app/workflow/instances/view/:record_id",
	action:(params, queryParams)->
		console.log("app.workflow.instances.view....")
		Session.set("instanceId", params.record_id);
		BlazeLayout.render 'workflowLayout',
			main: "workflow_main"