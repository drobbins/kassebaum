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

screenshotPath = "../../../../../tests/cucumber/screenshots"

module.exports = ->

    helper = @

    linkXpath = (text) -> "//a[contains(text(),\"#{text}\")]"
    linkTitleXpath = (text) -> "//a[@title='#{text}']"
    buttonXpath = (text) -> "//button[contains(text(),\"#{text}\")]"
    alertXpath = (text) -> "//div[contains(@class,\"alert\")][contains(text(),\"#{text}\")]"
    tdXpath = (text) -> "//td[contains(text(),\"#{text}\")]"
    h2Xpath = (text) -> "//h2[contains(text(),\"#{text}\")]"

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

    @.Given /^I should see a list of the "([^"]*)" (?:existing|matching) patients$/, (count, next) =>
        count = parseInt count, 10
        @world.browser
            .saveScreenshot "#{screenshotPath}/patienlist1.png" # makes it pass for some reason?
            .waitForVisible "//h2[contains(text(),\"Patients\")]"
            .elements "#patientList tbody tr", (err, result) ->
                rows = result.value
                if rows.length isnt count then next.fail("#{rows.length} patients found, expected #{count}") else next()

    @.When /^Enter the search term "([^"]*)"$/, (term, next) =>
        @.world.browser
            .setValue "input[name=search]", term
            .call next

    @.When /^I click on the "([^"]*)" patient link for patient "([^"]*)"$/, (operation, shortId, next) =>
        linkTitle = "#{operation} patient #{shortId} file."
        @.world.browser.click linkTitleXpath linkTitle
            .call next

    @.Then /^I should see the (?:details|edit page) for patient "([^"]*)"$/, (shortId, next) =>
        @.world.browser.getText "h2", (err, result) ->
            if result.match "Code: #{shortId}" then next() else next.fail "View Patient did not match #{shortId}. #{result}"