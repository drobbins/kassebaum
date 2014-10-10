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
    @route "logs",
        path: "/logs"
        template: "simpleLogs"
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
            Alert.add "Please log in to proceed.", "danger"
            @redirect "/"

requireAdmin = ->
    if not Roles.userIsInRole Meteor.user(), ["admin"]
        Alert.add "You must be an Admin to proceed.", "danger"
        @redirect "/"

logNavigation = ->
    if Meteor.user()
        Logs.add "info", "loaded #{@.path}"

Router.onBeforeAction requireLogin, except: ["home", "accessDenied", "modules"]
Router.onBeforeAction requireAdmin, except: ["home", "accessDenied", "modules", "addPatient"]
Router.onBeforeAction "loading"
Router.onAfterAction logNavigation, except: ["home", "accessDenied", "modules"]
