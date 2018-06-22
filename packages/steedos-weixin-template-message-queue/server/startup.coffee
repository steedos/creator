Meteor.startup ->
	console.log("00000000000000000000----------------==================")
	console.log(Meteor.settings.cron.weixin_template_message_queue_interval)
	if Meteor.settings.cron?.weixin_template_message_queue_interval
		console.log("11221212121212121----------------*********************************=================")
		WeixinTemplateMessageQueue.Configure
			sendInterval: Meteor.settings.cron.weixin_template_message_queue_interval
			sendBatchSize: 10
			keepDocs: false
