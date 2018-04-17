Meteor.startup ->
	# if Meteor.settings.cron?.instancerecordqueue_interval
		InstanceRecordQueue.Configure
			# sendInterval: Meteor.settings.cron.instancerecordqueue_interval
			sendInterval: 10000
			sendBatchSize: 10
			keepDocs: true
