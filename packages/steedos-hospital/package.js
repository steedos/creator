Package.describe({
	name: 'steedos:hospital',
	version: '0.0.1',
	summary: 'Patient informations',
	git: '',
	documentation: null
});

Package.onUse(function(api) {

	api.use('coffeescript@1.11.1_4');
	api.use('steedos:creator@0.0.4');
	api.addFiles('steedos-hospital.coffee');
	api.addFiles('models/care_records.coffee');
	api.addFiles('models/surgery_records.coffee');
	api.addFiles('models/healthy_records.coffee');
})