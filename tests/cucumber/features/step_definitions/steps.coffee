Data =
    tech:
        username: "kallie"
        password: "password"
        name: "Kallie Emil"
    admin:
        username: "admin"
        password: "password"
        name: "Admin"
    patient:
        firstName: "Adolphus"
        lastName: "McTestington"
        mrn: "1234512345"

module.exports = ->

    helper = @

    linkXpath = (text) -> "//a[contains(text(),\"#{text}\")]"
    buttonXpath = (text) -> "//button[contains(text(),\"#{text}\")]"

    @.Given /^I'm on the home page$/, (next) =>
        @.world.browser.url helper.world.cucumber.mirror.rootUrl
            .call next

    @.Given /^I'm logged in as a[n]? "([^"]*)"/, (role, next) =>
        @.world.browser
            .executeAsync (done) -> Meteor.logout(done)
            .waitForVisible linkXpath("Sign in")
            .click linkXpath "Sign in"
            .setValue "#login-username", Data[role].username
            .setValue "#login-password", Data[role].password
            .click '//button[@id="login-buttons-password"]'
            .waitForExist linkXpath Data[role].name
            .call next

    @.Given /the "([^"]*)" link should be visible./, (text, next) =>
        @.world.browser.waitForVisible linkXpath(text)
            .call next