Router.configure
    layoutTemplate: "layout"
    loadingTemplate: "loading"

Router.map ->
    @route "home",
        path: "/"
        template: "loading"
    @route "admin",
        path: "admin"
        template: "accountsAdmin"
        onBeforeAction: ->
            if Meteor.loggingIn()
                @render @loadingTemplate
            else if not Roles.userIsInRole Meteor.user(), ["admin"]
                console.log "Redirecting"
                @redirect "/"
