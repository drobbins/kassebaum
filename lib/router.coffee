Router.configure
    layoutTemplate: "layout"
    loadingTemplate: "loading"

Router.map ->
    @route "home",
        path: "/"
        template: "home"
    @route "admin",
        path: "/admin"
        template: "accountsAdmin"
        onBeforeAction: ->
            if Meteor.loggingIn()
                @render @loadingTemplate
            else if not Roles.userIsInRole Meteor.user(), ["admin"]
                @redirect "/"
    @route "modules",
        path: "/modules"
        template: "modules"
        onBeforeAction: ->
            HTTP.get "http://minervajs.org/lib", (error, result) ->
                Session.set "minervaModules", result.data
    @route "listPatients",
        path: "/patients"
        template: "listPatients"
        waitOn: ->
            Meteor.subscribe "patients"
    @route "addPatient",
        path: "/patients/new"
        template: "addPatient"
    @route "viewPatient",
        path: "/patients/:_id"
        template: "viewPatient"
        data: -> Patients.findOne @params._id
        waitOn: ->
            Meteor.subscribe "patients"
    @route "editPatient",
        path: "/patients/:_id/edit"
        template: "editPatient"
        data: -> Patients.findOne @params._id
        waitOn: ->
            Meteor.subscribe "patients"

requireLogin = ->
    if not Meteor.user()
        if Meteor.loggingIn()
            @render @loadingTemplate
        else
            Alerts.add "Please log in to proceed."
            @redirect "/"

requireAdmin = ->
    if not Roles.userIsInRole Meteor.user(), ["admin"]
        Alerts.add "You must be an Admin to proceed."
        @redirect "/"

Router.onBeforeAction "loading"
Router.onBeforeAction requireLogin, except: ["home", "accessDenied", "modules"]
Router.onBeforeAction requireAdmin, except: ["home", "accessDenied", "modules", "addPatient"]
