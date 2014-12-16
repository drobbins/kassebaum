module.exports = ->

    helper = @

    linkXpath = (text) -> "//a[contains(text(),\"#{text}\")]"

    @.Given /^I'm on the home page$/, (next) =>
        @.world.browser.url helper.world.cucumber.mirror.rootUrl
            .call next

    @.Given /The "([^"]*)" link should be visible./, (text, next) =>
        @.world.browser.getHTML linkXpath(text), (error, actualText) ->
            if not actualText.match text
                next.fail "#{actualText} did not match #{text}"
            else
                next()