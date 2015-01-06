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
        connection = DDP.connect @.world.cucumber.mirror.host
        connection.call "/fixtures/reloadpatients", (err, res) ->
            if err then next.fail(err) else next()

    @.After =>
        next = arguments[arguments.length - 1]
        @.world.browser.end().call next