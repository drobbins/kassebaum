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
    alertXpath = (text) -> "//div[contains(@class,\"alert\")][contains(text(),\"#{text}\")]"
    tdXpath = (text) -> "//td[contains(text(),\"#{text}\")]"

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

    @.Given /the "([^"]*)" link (?:is|should be) visible/, (text, next) =>
        @.world.browser.waitForVisible linkXpath(text)
            .call next

    @.Given /the "([^"]*)" link is not visible$/, (text, next) =>
        @.world.browser.isVisible linkXpath(text), (err, visible) ->
            if visible is true then next.fail "Expected #{text} link to not be visible, but it was."
            else next()

    @.When /I click on the "([^"]*)" link/, (text, next) =>
        @.world.browser.click linkXpath text
            .call next

    @.When /enter and submit a test patient/, (next) =>
        @.world.browser
            .setValue "input[name=mrn]", Data.patient.mrn
            .setValue "input[name=firstName]", Data.patient.firstName
            .setValue "input[name=lastName]", Data.patient.lastName
            .click buttonXpath "Save Patient"
            .call next

    @.Given /an alert with "([^"]*)" should be displayed/, (text, next) =>
        @.world.browser.waitForVisible alertXpath(text)
            .call next

    @.Given /the new patient should appear in the patient list/, (next) =>
        @world.browser.click linkXpath "Patients"
            .waitForVisible tdXpath Data.patient.mrn
            .call next