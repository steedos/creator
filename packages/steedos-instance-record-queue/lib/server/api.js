var isConfigured = false;
var sendWorker = function (task, interval) {

	if (InstanceRecordQueue.debug) {
		console.log('InstanceRecordQueue: Send worker started, using interval: ' + interval);
	}

	return Meteor.setInterval(function () {
		try {
			task();
		} catch (error) {
			console.log('InstanceRecordQueue: Error while sending: ' + error.message);
		}
	}, interval);
};

/*
	options: {
		// Controls the sending interval
		sendInterval: Match.Optional(Number),
		// Controls the sending batch size per interval
		sendBatchSize: Match.Optional(Number),
		// Allow optional keeping notifications in collection
		keepDocs: Match.Optional(Boolean)
	}
*/
InstanceRecordQueue.Configure = function (options) {
	var self = this;
	options = _.extend({
		sendTimeout: 60000, // Timeout period
	}, options);

	// Block multiple calls
	if (isConfigured) {
		throw new Error('InstanceRecordQueue.Configure should not be called more than once!');
	}

	isConfigured = true;

	// Add debug info
	if (InstanceRecordQueue.debug) {
		console.log('InstanceRecordQueue.Configure', options);
	}

	self.sendDoc = function (doc) {
		if (InstanceRecordQueue.debug) {
			console.log("sendDoc");
			console.log(doc);
		}

		// Edoc.send(doc.doc);
		var insId = doc.info.instance_id,
			records = doc.info.records;
		var ins = Creator.getCollection('instances').findOne(insId);
		var values = ins.values;
		var ow = Creator.getCollection('object_workflows').findOne({
			object_name: records.o,
			flow_id: ins.flow
		});
		var setObj, objectCollection = Creator.getCollection(records.o);
		objectCollection.find({
			_id: {
				$in: records.ids
			}
		}).forEach(function (record) {
			setObj = {};
			ow.field_map.forEach(function (fm) {
				if (values.hasOwnProperty(fm.workflow_field)) {
					setObj[fm.object_field] = values[fm.workflow_field];
				}
			})
			if (!_.isEmpty(setObj)) {
				objectCollection.update(record._id, {
					$set: setObj
				})
			}
		})

		InstanceRecordQueue.collection.update(doc._id, {
			$set: {
				'info.sync_date': new Date()
			}
		})

	}

	// Universal send function
	var _querySend = function (doc) {

		if (self.sendDoc) {
			self.sendDoc(doc);
		}

		return {
			doc: [doc._id]
		};
	};

	self.serverSend = function (doc) {
		doc = doc || {};
		return _querySend(doc);
	};


	// This interval will allow only one doc to be sent at a time, it
	// will check for new docs at every `options.sendInterval`
	// (default interval is 15000 ms)
	//
	// It looks in docs collection to see if theres any pending
	// docs, if so it will try to reserve the pending doc.
	// If successfully reserved the send is started.
	//
	// If doc.query is type string, it's assumed to be a json string
	// version of the query selector. Making it able to carry `$` properties in
	// the mongo collection.
	//
	// Pr. default docs are removed from the collection after send have
	// completed. Setting `options.keepDocs` will update and keep the
	// doc eg. if needed for historical reasons.
	//
	// After the send have completed a "send" event will be emitted with a
	// status object containing doc id and the send result object.
	//
	var isSendingDoc = false;

	if (options.sendInterval !== null) {

		// This will require index since we sort docs by createdAt
		InstanceRecordQueue.collection._ensureIndex({
			createdAt: 1
		});
		InstanceRecordQueue.collection._ensureIndex({
			sent: 1
		});
		InstanceRecordQueue.collection._ensureIndex({
			sending: 1
		});


		var sendDoc = function (doc) {
			// Reserve doc
			var now = +new Date();
			var timeoutAt = now + options.sendTimeout;
			var reserved = InstanceRecordQueue.collection.update({
				_id: doc._id,
				sent: false, // xxx: need to make sure this is set on create
				sending: {
					$lt: now
				}
			}, {
				$set: {
					sending: timeoutAt,
				}
			});

			// Make sure we only handle docs reserved by this
			// instance
			if (reserved) {

				// Send
				var result = InstanceRecordQueue.serverSend(doc);

				if (!options.keepDocs) {
					// Pr. Default we will remove docs
					InstanceRecordQueue.collection.remove({
						_id: doc._id
					});
				} else {

					// Update
					InstanceRecordQueue.collection.update({
						_id: doc._id
					}, {
						$set: {
							// Mark as sent
							sent: true,
							// Set the sent date
							sentAt: new Date(),
							// Not being sent anymore
							sending: 0
						}
					});

				}

				// // Emit the send
				// self.emit('send', {
				// 	doc: doc._id,
				// 	result: result
				// });

			} // Else could not reserve
		}; // EO sendDoc

		sendWorker(function () {

			if (isSendingDoc) {
				return;
			}
			// Set send fence
			isSendingDoc = true;

			var batchSize = options.sendBatchSize || 1;

			var now = +new Date();

			// Find docs that are not being or already sent
			var pendingDocs = InstanceRecordQueue.collection.find({
				$and: [
					// Message is not sent
					{
						sent: false
					},
					// And not being sent by other instances
					{
						sending: {
							$lt: now
						}
					},
					// And no error
					{
						errMsg: {
							$exists: false
						}
					}
				]
			}, {
				// Sort by created date
				sort: {
					createdAt: 1
				},
				limit: batchSize
			});

			pendingDocs.forEach(function (doc) {
				try {
					sendDoc(doc);
				} catch (error) {
					console.error(error.stack);
					console.log('InstanceRecordQueue: Could not send doc id: "' + doc._id + '", Error: ' + error.message);
					InstanceRecordQueue.collection.update({
						_id: doc._id
					}, {
						$set: {
							// error message
							errMsg: error.message
						}
					});
				}
			}); // EO forEach

			// Remove the send fence
			isSendingDoc = false;
		}, options.sendInterval || 15000); // Default every 15th sec

	} else {
		if (InstanceRecordQueue.debug) {
			console.log('InstanceRecordQueue: Send server is disabled');
		}
	}

};