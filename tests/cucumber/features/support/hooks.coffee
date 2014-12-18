module.exports = ->
    helper = @

    size =
        width: 800
        height: 600

    @.Before ->
        next = arguments[arguments.length - 1]
        helper.world.browser.init()
            .setViewportSize(size)
            .call next

    @.After ->
        next = arguments[arguments.length - 1]
        helper.world.browser.end().call next