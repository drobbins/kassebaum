Package.describe({
    summary: 'Simple collection based logging.',
    version: '0.0.0',
    name: 'robbinsd:simplelog'
});

Package.onUse(function(api) {
    api.versionsFrom('METEOR@0.9.0.1');
    api.use('ecmascript');
    api.use('standard-app-packages');
    if (api.export) api.export('Logs');
    api.addFiles('simplelog.js');
    api.addFiles('simplelog-templates.html', 'client');
    api.addFiles('simplelog-templates.js', 'client');
});

Package.onTest(function(api) {
    api.use('tinytest');
    api.use('robbinsd:simplelog');
    api.addFiles('simplelog-tests.js');
});
