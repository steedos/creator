schedule = Npm.require('node-schedule')

RecordsSync = {}

#	*    *    *    *    *    *
#	┬    ┬    ┬    ┬    ┬    ┬
#	│    │    │    │    │    |
#	│    │    │    │    │    └ day of week (0 - 7) (0 or 7 is Sun)
#	│    │    │    │    └───── month (1 - 12)
#	│    │    │    └────────── day of month (1 - 31)
#	│    │    └─────────────── hour (0 - 23)
#	│    └──────────────────── minute (0 - 59)
#	└───────────────────────── second (0 - 59, OPTIONAL)

logger = new Logger 'RecordsSync'

RecordsSync.settings_records_sync = Meteor.settings?.records_sync

RecordsSync.scheduleJobMaps = {}

RecordsSync.run = ()->
	try
		RecordsSync.instanceToArchive()
	catch  e
		logger.error "RecordsSync.instanceToArchive", e

# RecordsSync.instanceToArchive()
# RecordsSync.instanceToArchive(["jXib7XrPu6FqWSKXH"])
RecordsSync.instanceToArchive = (ins_ids)->

	spaces = RecordsSync?.settings_records_sync?.spaces

	# 需要同步的流程
	need_recorded_flows = RecordsSync?.settings_records_sync?.need_recorded_flows

	if !spaces
		logger.error "缺少settings配置: records-sync.spaces"
		return
	
	if !need_recorded_flows
		logger.error "缺少settings配置: records-sync.need_recorded_flows"
		return

	instancesToArchive = new InstancesToArchive(spaces, need_recorded_flows, ins_ids)

	instancesToArchive.syncInstances()

RecordsSync.startScheduleJob = (name, recurrenceRule, fun) ->

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
		RecordsSync.scheduleJobMaps[name] = schedule.scheduleJob recurrenceRule, fun

if RecordsSync.settings_records_sync?.recurrenceRule
	RecordsSync.startScheduleJob "RecordsSync.instanceToArchive", RecordsSync.settings_records_sync?.recurrenceRule, Meteor.bindEnvironment(RecordsSync.run)
