Package.describe({
    summary: "Simple collection based logging.",
    version: "0.0.0"
});

Package.onUse(function(api) {
    api.versionsFrom('METEOR@0.9.0.1');
    api.use("coffeescript"),
    api.use("standard-app-packages");
    if (api.export) api.export("Logs");
    api.addFiles("robbinsd:simplelog.coffee");
    api.addFiles("robbinsd:simplelog-templates.html", "client");
    api.addFiles("robbinsd:simplelog-templates.coffee", "client");
});

Package.onTest(function(api) {
    api.use('tinytest');
    api.use('robbinsd:simplelog');
    api.addFiles('robbinsd:simplelog-tests.js');
});
