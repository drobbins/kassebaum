module.exports = ->

    helper = @

    @.World = (next) ->
        world = helper.world = @

        world.cucumber = Package['xolvio:cucumber'].cucumber
        world.wdio = Package['xolvio:webdriver'].wdio

        options = 
            desiredCapabilities: {browserName: 'PhantomJs'},
            port: 4444,
            logLevel: 'silent'

        world.wdio.getGhostDriver options, (browser) ->
            world.browser = browser
            browser.call next