module.exports = ->

    size =
        width: 800
        height: 600

    @.Before =>
        next = arguments[arguments.length - 1]
        @.world.browser.init()
            .setViewportSize(size)
            .call next

    @.Before =>
        next = arguments[arguments.length - 1]
        @.world.browser.url @.world.cucumber.mirror.rootUrl
            .executeAsync (done) -> Meteor.call("/fixtures/reloadpatients", done)
            .call next

    @.After =>
        next = arguments[arguments.length - 1]
        @.world.browser.end().call next