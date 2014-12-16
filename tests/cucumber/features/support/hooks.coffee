module.exports = ->
    helper = @

    @.Before ->
        next = arguments[arguments.length - 1]
        helper.world.browser.init().call next

    @.After ->
        next = arguments[arguments.length - 1]
        helper.world.browser.end().call next