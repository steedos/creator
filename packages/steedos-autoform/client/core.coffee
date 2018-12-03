@TabularTables = {};


Meteor.startup ->
	console.log('SimpleSchema.extendOptions beforeOpenFunction...');
	SimpleSchema.extendOptions({beforeOpenFunction: Match.Optional(Match.OneOf(Function, String))})