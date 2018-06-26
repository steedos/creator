schedule = Npm.require('node-schedule')

XMLSync = {}

#	*    *    *    *    *    *
#	┬    ┬    ┬    ┬    ┬    ┬
#	│    │    │    │    │    |
#	│    │    │    │    │    └ day of week (0 - 7) (0 or 7 is Sun)
#	│    │    │    │    └───── month (1 - 12)
#	│    │    │    └────────── day of month (1 - 31)
#	│    │    └─────────────── hour (0 - 23)
#	│    └──────────────────── minute (0 - 59)
#	└───────────────────────── second (0 - 59, OPTIONAL)

logger = new Logger 'XML_Sync'

XMLSync.settings_records_xml = Meteor.settings?.records_xml

XMLSync.scheduleJobMaps = {}

XMLSync.run = ()->
	try
        # 执行同步
		XMLSync.records2Xml()
	catch  e
		logger.error "XML_Sync.records2Xml()", e

# XMLSync.records2Xml()
XMLSync.records2Xml = (record_ids)->

	spaces = XMLSync?.settings_records_xml?.spaces

	if !spaces
		logger.error "缺少settings配置: records-qhd.spaces"
		return

	# Records2XML = new Records2XML(spaces, record_ids)

	# Records2XML.syncRecords()

XMLSync.startScheduleJob = (name, recurrenceRule, fun) ->

	if !recurrenceRule
		logger.error "Miss recurrenceRule"
		return
	if !_.isString(recurrenceRule)
		logger.error "RecurrenceRule is not String. https://github.com/node-schedule/node-schedule"
		return

	if !fun
		logger.error "Miss function"
	else if !_.isFunction(fun)
		logger.error "#{fun} is not function"
	else
		logger.info "Add scheduleJobMaps: #{name}"
		XMLSync.scheduleJobMaps[name] = schedule.scheduleJob recurrenceRule, fun

if XMLSync.settings_records_xml?.recurrenceRule
	XMLSync.startScheduleJob "XMLSync.records2Xml", XMLSync.settings_records_xml?.recurrenceRule, Meteor.bindEnvironment(XMLSync.run)