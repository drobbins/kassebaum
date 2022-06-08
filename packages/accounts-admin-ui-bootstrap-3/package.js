Package.describe({
	summary: "A roles based account management system using bootstrap 3",
  version: "0.0.0",
  name: "robbinsd:meteor-accounts-admin-ui-bootstrap-3"
});

Package.onUse(function (api, where) {
  api.versionsFrom("METEOR@0.9.0");
	api.use('standard-app-packages', ['client', 'server']);
	api.use("alanning:roles", ['client', 'server']);

	api.addFiles('libs/user_query.js', ['client', 'server']);

	api.addFiles('client/startup.js', 'client');
	api.addFiles('client/accounts_admin.html', 'client');
	api.addFiles('client/accounts_admin.js', 'client');
	api.addFiles('client/delete_account_modal.html', 'client');
	api.addFiles('client/delete_account_modal.js', 'client');
	api.addFiles('client/info_account_modal.html', 'client');
	api.addFiles('client/info_account_modal.js', 'client');
	api.addFiles('client/update_account_modal.html', 'client');
	api.addFiles('client/update_account_modal.js', 'client');
	api.addFiles('client/update_roles_modal.html', 'client');
	api.addFiles('client/update_roles_modal.js', 'client');

	api.addFiles('style/style.css', 'client');

	api.addFiles('server/startup.js', 'server');
	api.addFiles('server/publish.js', 'server');
	api.addFiles('server/methods.js', 'server');
});
