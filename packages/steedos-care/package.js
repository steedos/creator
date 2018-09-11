Package.describe({
	name: 'steedos:care',
	version: '0.0.1',
	summary: 'Patient informations',
	git: '',
	documentation: null
});

Package.onUse(function(api) {

	api.use('coffeescript@1.11.1_4');
	api.use('steedos:creator@0.0.4');
	api.addFiles('steedos-care.coffee');
	api.addFiles('models/care_medical_records.coffee');
	api.addFiles('models/care_surgery_records.coffee');
	api.addFiles('models/care_healthy_records.coffee');
})